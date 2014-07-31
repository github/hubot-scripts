# Description:
#   Interact with Gerrit. (http://code.google.com/p/gerrit/)
#
# Dependencies:
#
# Configuration:
#   HUBOT_GERRIT_SSH_URL
#   HUBOT_GERRIT_EVENTSTREAM_ROOMS
#
# Commands:
#   hubot gerrit search <query> - Search Gerrit for changes - the query should follow the normal Gerrit query rules
#   hubot gerrit (ignore|report) events for (project|user|event) <thing> - Tell Hubot how to report Gerrit events
#
# Notes:
#   Hubot has to be running as a user who has registered a SSH key with Gerrit
#
# Author:
#   nparry

cp = require "child_process"
url = require "url"

# Required - The SSH URL for your Gerrit server.
sshUrl = process.env.HUBOT_GERRIT_SSH_URL || ""

# Optional - A comma separated list of rooms to receive spam about Gerrit events.
#   If not set, messages will be sent to all room of which Hubot is a member.
#   To disable event stream spam, use the value "disabled"
eventStreamRooms = process.env.HUBOT_GERRIT_EVENTSTREAM_ROOMS

# TODO: Make these template driven with env-var overrides possible.
# See the following for descriptions of the input JSON data:
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/json.html
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.4/cmd-stream-events.html
formatters =
  queryResult:          (json) -> "'#{json.change.subject}' for #{json.change.project}/#{json.change.branch} by #{extractName json.change} on #{formatDate json.change.lastUpdated}: #{json.change.url}"
  events:
    "patchset-created": (json) -> "#{extractName json} uploaded patchset #{json.patchSet.number} of '#{json.change.subject}' for #{json.change.project}/#{json.change.branch}: #{json.change.url}"
    "change-abandoned": (json) -> "#{extractName json} abandoned '#{json.change.subject}' for #{json.change.project}/#{json.change.branch}: #{json.change.url}"
    "change-restored":  (json) -> "#{extractName json} restored '#{json.change.subject}' for #{json.change.project}/#{json.change.branch}: #{json.change.url}"
    "change-merged":    (json) -> "#{extractName json} merged patchset #{json.patchSet.number} of '#{json.change.subject}' for #{json.change.project}/#{json.change.branch}: #{json.change.url}"
    "comment-added":    (json) -> "#{extractName json} reviewed patchset #{json.patchSet.number} (#{extractReviews json}) of '#{json.change.subject}' for #{json.change.project}/#{json.change.branch}: #{json.change.url}"
    "ref-updated":      (json) -> "#{extractName json} updated reference #{json.refUpdate.project}/#{json.refUpdate.refName}"

formatDate = (seconds) -> new Date(seconds * 1000).toDateString()
extractName = (json) ->
  account = json.uploader || json.abandoner || json.restorer || json.submitter || json.author || json.owner
  account?.name || account?.email || "Gerrit"
extractReviews = (json) ->
  ("#{a.description}=#{a.value}" for a in json.approvals).join ","

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
  cp.exec "ssh #{gerrit.hostname} -p #{gerrit.port} gerrit query --format=JSON -- #{msg.match[1]}", (err, stdout, stderr) ->
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
        msg.send formatters.queryResult change: r for r in results when r.id

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
    isIgnored("project", (event.change || event.refUpdate).project) ||
    isIgnored("user", extractName event) ||
    isIgnored("event", event.type))

  streamEvents.stderr.on "data", (data) ->
    robot.logger.info "Gerrit stream-events: #{data}"
  streamEvents.stdout.on "data", (data) ->
    robot.logger.debug "Gerrit stream-events: #{data}"
    json = try
      JSON.parse data
    catch error
      robot.logger.error "Gerrit stream-events: Error parsing Gerrit JSON. Error=#{error}, Event=#{data}"
      null
    return unless json
    formatter = formatters.events[json.type]
    msg = try
      formatter json if formatter
    catch error
      robot.logger.error "Gerrit stream-events: Error formatting event. Error=#{error}, Event=#{data}"
      null
    if formatter == null
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
