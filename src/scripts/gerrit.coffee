# Interact with Gerrit. (http://code.google.com/p/gerrit/)
# Hubot has to be running as a user who has registered a SSH key with Gerrit.
#
# hubot gerrit search <query> - Search Gerrit for changes - the query should follow the normal Gerrit query rules.
# hubot gerrit (ignore|report) events for (project|user|event) <thing> - Tell Hubot how to report Gerrit events.
#

# Required - The SSH URL for your Gerrit server.
sshUrl = process.env.HUBOT_GERRIT_SSH_URL || ""

# Optional - A comma separated list of rooms to receive spam about Gerrit events.
#   If not set, messages will be sent to all room of which Hubot is a member.
#   To disable event stream spam, use the value "disabled"
eventStreamRooms = process.env.HUBOT_GERRIT_EVENTSTREAM_ROOMS

cp = require "child_process"
url = require "url"

# Format JSON query result (see http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html#change)
formatQueryResult = (r) ->
  updated = new Date(r.lastUpdated * 1000).toDateString()
  "'#{r.subject}' for #{r.project}/#{r.branch} by #{extractName r} on #{updated}: #{r.url}"

# Format JSON event data (see http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/cmd-stream-events.html)
formatEvent = (e) ->
  switch e.type
    when "patchset-created" then formatPatchsetEvent "New patchset", e
    when "change-abandoned" then formatPatchsetEvent "Patchset abandoned", e
    when "change-restored"  then formatPatchsetEvent "Patchset restored", e
    when "change-merged"    then formatPatchsetEvent "Patchset merged", e
    when "comment-added"    then formatPatchsetEvent "New comments", e
    when "ref-updated"      then "Ref updated - #{extractProject e}/#{e.refUpdate.refName} by #{extractName e}"
    else null

formatPatchsetEvent = (type, e) ->
  "#{type} - '#{e.change.subject}' for #{extractProject e}/#{e.change.branch} by #{extractName e}: #{e.change.url}"

# Format name given best available data. This tries to find an 'account' object
# given either a 'change' object or a gerrit event-stream object. See...
# - http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html#account
# - http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html#change
# - http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/cmd-stream-events.html
extractName = (json) ->
  account = json.uploader || json.abandoner || json.restorer || json.submitter || json.author || json.owner
  account?.name || account?.email || "Gerrit"

extractProject = (json) -> (json.change || json.refUpdate).project

module.exports = (robot) ->
  gerrit = url.parse sshUrl
  gerrit.port = 22 unless gerrit.port
  if gerrit.protocol != "ssh:" || gerrit.hostname == ""
    robot.logger.error "Gerrit commands inactive because HUBOT_GERRIT_SSH_URL=#{gerrit.href} is not a valid SSH URL"
  else
    eventStreamMe robot, gerrit unless eventStreamRooms == "disabled"
    robot.respond /gerrit (?:search|query)(?: me)? (.+)/i, searchMe robot, gerrit
    robot.respond /gerrit (ignore|report)(?: me)? events for (project|user|event) (.+)/i, ignoreOrReportEventsMe robot, gerrit

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
  type = msg.match[2].toLowerCase()
  thing = msg.match[3]
  ignores = (t for t in ignoresOfType robot, type when t isnt thing)
  ignores.push thing if msg.match[1] == "ignore"

  robot.brain.data.gerrit ?= { }
  robot.brain.data.gerrit.eventStream ?= { }
  robot.brain.data.gerrit.eventStream.ignores ?= { }
  robot.brain.data.gerrit.eventStream.ignores[type] = ignores
  msg.send "Got it, the updated list of Gerrit #{type}s to ignore is #{ignores.join(', ') || 'empty'}"

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

  isIgnored = (type, thing) -> (t for t in ignoresOfType robot, type when t is thing).length != 0
  isWanted = (event) -> !(
    isIgnored("project", extractProject event) ||
    isIgnored("user", extractName event) ||
    isIgnored("event", event.type))

  streamEvents.stderr.on "data", (data) ->
    robot.logger.info "Gerrit stream-events: #{data}"
  streamEvents.stdout.on "data", (data) ->
    json = JSON.parse data
    msg = formatEvent json
    if msg == null
      robot.logger.info "Gerrit stream-events: Unrecognized event #{data}"
    else if msg && isWanted json
      # Bug in messageRoom? Doesn't work with multiple rooms
      #robot.messageRoom room, "Gerrit: #{msg}" for room in robotRooms robot
      robot.send room: room, "Gerrit: #{msg}" for room in robotRooms robot

ignoresOfType = (robot, type) -> robot.brain.data.gerrit?.eventStream?.ignores?[type] || []

robotRooms = (robot) ->
  roomlists =
    if eventStreamRooms
      [ eventStreamRooms ]
    else
      v for k,v of process.env when /^HUBOT_.+_ROOMS/i.exec(k) isnt null
  robot.logger.error "Gerrit stream-events: Unable to determine the list of rooms" if roomlists.length == 0
  r for r in (roomlists[0] || "").split "," when r isnt ""
