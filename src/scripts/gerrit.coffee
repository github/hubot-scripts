# Interact with Gerrit. (http://code.google.com/p/gerrit/)
# Hubot has to be running as a user who has registered a SSH key with Gerrit.
#
# hubot gerrit search <query> - Search Gerrit for changes - the query should follow the normal Gerrit query rules.
# hubot gerrit ignore events for <project> - Don't spam about events happening for the specified project.
# hubot gerrit report events for <project> - Reset Hubot to spam about events happening for the specified project.
#

cp = require "child_process"
url = require "url"

# Format JSON query result (see http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html#change)
formatQueryResult = (r) ->
  updated = new Date(r.lastUpdated * 1000).toDateString()
  "'#{r.subject}' for #{r.project}/#{r.branch} by #{nameOf r.owner} on #{updated}: #{r.url}"

# Format JSON event data (see http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/cmd-stream-events.html)
formatEvent = (e) ->
  switch e.type
    when "patchset-created" then formatPatchsetEvent "New patchset", e.change, e.uploader
    when "change-abandoned" then formatPatchsetEvent "Patchset abandoned", e.change, e.abandoner
    when "change-restored"  then formatPatchsetEvent "Patchset restored", e.change, e.restorer
    when "change-merged"    then formatPatchsetEvent "Patchset merged", e.change, e.submitter
    when "comment-added"    then formatPatchsetEvent "New comments", e.change, e.author
    when "ref-updated"      then "Ref updated - #{e.refUpdate.project}/#{e.refUpdate.refName} by #{e.submitter.name}"
    else null

formatPatchsetEvent = (type, change, who) ->
  "#{type} - '#{change.subject}' for #{change.project}/#{change.branch} by #{nameOf who}: #{change.url}"

# Format name given best available data (see http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html#account)
nameOf = (account) -> account?.name || account?.email || "Gerrit"

module.exports = (robot) ->
  gerrit = url.parse process.env.HUBOT_GERRIT_SSH_URL || ""
  gerrit.port = 22 unless gerrit.port
  if gerrit.protocol != "ssh:" || gerrit.hostname == ""
    robot.logger.error "Gerrit commands inactive because HUBOT_GERRIT_SSH_URL=#{gerrit.href} is not a valid SSH URL"
  else
    eventStreamMe robot, gerrit
    robot.respond /gerrit (?:search|query)(?: me)? (.+)/i, searchMe robot, gerrit
    robot.respond /gerrit (ignore|report)(?: me)? events for (.+)/i, ignoreOrReportEventsMe robot, gerrit

searchMe = (robot, gerrit) -> (msg) ->
  cp.exec "ssh #{gerrit.hostname} -p #{gerrit.port} gerrit query --format=JSON #{msg.match[1]}", (err, stdout, stderr) ->
    if err
      msg.send "Sorry, something went wrong talking with Gerrit: #{stderr}"
    else
      results = (JSON.parse l for l in stdout.split "\n" when l isnt "")
      status = results[results.length - 1]
      if status.type == "error"
        msg.send "Sorry, Gerrit didn't like your query: #{status.message}"
      else if status.rowCount == 0
        msg.send "Gerrit didn't find anything matching your query"
      else
        msg.send formatQueryResult r for r in results when r.id

ignoreOrReportEventsMe = (robot, gerrit) -> (msg) ->
  project = msg.match[2]
  ignoredProjects = (p for p in (robot.brain.data.gerrit?.eventStream?.ignoredProjects || []) when p isnt project)
  ignoredProjects.push project if msg.match[1] == "ignore"

  robot.brain.data.gerrit ?= { }
  robot.brain.data.gerrit.eventStream ?= { }
  robot.brain.data.gerrit.eventStream.ignoredProjects = ignoredProjects
  msg.send "Got it, the updated list of Gerrit projects to ignore is #{ignoredProjects.join(', ') || 'empty'}"

eventStreamMe = (robot, gerrit) ->
  robot.logger.info "Gerrit stream-events: Starting connection"
  streamEvents = cp.spawn "ssh", [gerrit.hostname, "-p", gerrit.port, "gerrit", "stream-events"]
  done = false
  reconnect = null

  robot.brain.on "close", ->
    done = true
    clearTimeout reconnect if reconnect
    streamEvents.stdin.end()
  streamEvents.on "exit", (code) ->
    robot.logger.info "Gerrit stream-events: Connection lost (rc=#{code})"
    reconnect = setTimeout (-> eventStreamMe robot, gerrit), 10 * 1000 unless done

  projectFor = (json) -> (json.change || json.refUpdate).project
  isWanted = (project) -> (p for p in (robot.brain.data.gerrit?.eventStream?.ignoredProjects || []) when p is project).length == 0

  streamEvents.stderr.on "data", (data) ->
    robot.logger.info "Gerrit stream-events: #{data}"
  streamEvents.stdout.on "data", (data) ->
    json = JSON.parse data
    msg = formatEvent json
    if msg == null
      robot.logger.info "Gerrit stream-events: Unrecognized event #{data}"
    else if msg && isWanted projectFor json
      robot.messageRoom room, "Gerrit: #{msg}" for room in robotRooms robot

# So this is kind of terrible - not sure of a better way to do this for now
robotRooms = (robot) ->
  roomlistish = /^HUBOT_.+_ROOMS/i
  roomlists = (v for k,v of process.env when roomlistish.exec(k) isnt null)
  if roomlists.length != 0
    roomlists[0].split(",")
  else
    robot.logger.error "Gerrit stream-events: Unable to determine the list of rooms"
    [ "dummy" ]
