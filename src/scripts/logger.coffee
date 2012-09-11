# Description:
#   Logs chat to Redis and displays it over HTTP
#
# Dependencies:
#   "redis": ">=0.7.2"
#   "moment": ">=1.7.0"
#   "connect": ">=2.4.5"
#   "connect_router": "*"
#
# Configuration:
#   LOG_REDIS_URL: URL to Redis backend to use for logging (uses REDISTOGO_URL 
#                  if unset, and localhost:6379 if that is unset.
#   LOG_HTTP_USER: username for viewing logs over HTTP (default 'logs' if unset)
#   LOG_HTTP_PASS: password for viewing logs over HTTP (default 'changeme' if unset)
#   LOG_HTTP_PORT: port for our logging Connect server to listen on (default 8081)
#   LOG_STEALTH:   If set, bot will not announce that it is logging in chat
#   LOG_MESSAGES_ONLY: If set, bot will not log room enter or leave events
#
# Commands:
#   hubot send me today's logs - messages you the logs for today
#   hubot what did I miss - messages you logs for the past 10 minutes
#   hubot what did I miss in the last x seconds/minutes/hours - messages you logs for the past x
#   hubot start logging - start logging messages from now on
#   hubot stop logging  - stop logging messages for the next 15 minutes
#   hubot stop logging forever - stop logging messages indefinitely
#   hubot stop logging for x seconds/minutes/hours - stop logging messages for the next x
#   i request the cone of silence - stop logging for the next 15 minutes
#
# Notes:
#   This script by default starts a Connect server on 8081 with the following routes:
#     /
#       Form that takes a room ID and two UNIX timestamps to show the logs between.
#       Action is a GET with room, start, and end parameters to /logs/view.
#
#     /logs/view?room=room_name&start=1234567890&end=1456789023
#       Shows logs between UNIX timestamps <start> and <end> for <room>
#
#     /logs/:room
#       Lists all logs in the database for <room>
#
#     /logs/:room/YYYMMDD
#       Lists all logs in <room> for the date YYYYMMDD
#
#   Feel free to edit the HTML views at the bottom of this module if you want to make the views
#   prettier or more functional.
#
#   I have only thoroughly tested this script with the xmpp and shell adapters. It doesn't use
#   anything that necessarily wouldn't work with other adapters, but it's possible some adapters
#   may have issues sending large amounts of logs in a single message.
#
# Author:
#   jenrzzz


Redis = require "redis"
Url   = require "url"
Util  = require "util"
Connect = require "connect"
Connect.router = require "connect_router"
OS = require "os"
moment = require "moment"
hubot = require "hubot"

# Convenience class to represent a log entry
class Entry
 constructor: (from, timestamp, type='text', message='') ->
    @from = from
    @timestamp = timestamp
    @type = type
    @message = message

redis_server = Url.parse process.env.LOG_REDIS_URL || process.env.REDISTOGO_URL || 'redis://localhost:6379'

module.exports = (robot) ->
  robot.logging ||= {} # stores some state info that should not persist between application runs
  robot.brain.data.logging ||= {}
  robot.logger.debug "Starting chat logger."

  # Setup our own redis connection
  client = Redis.createClient redis_server.port, redis_server.hostname
  if redis_server.auth
    client.auth redis_server.auth.split(":")[1]
  client.on 'error', (err) ->
    robot.logger.error "Chat logger was unable to connect to a Redis backend at #{redis_server.hostname}:#{redis_server.port}"
    robot.logger.error err
  client.on 'connect', ->
    robot.logger.debug "Chat logger successfully connected to Redis."

  # Add a listener that matches all messages and calls log_message with redis and robot instances and a Response object
  robot.listeners.push new hubot.Listener(robot, ((msg) -> return true), (res) -> log_message(client, robot, res))

  # Setup a very minimalistic Connect server for viewing logs
  connect = Connect()
  connect.use Connect.basicAuth(process.env.LOG_HTTP_USER || 'logs', process.env.LOG_HTTP_PASS || 'changeme')
  connect.use Connect.bodyParser()
  connect.use Connect.query()
  connect.use Connect.router (app) ->
    app.get '/', (req, res) ->
      res.statusCode = 200
      res.setHeader 'Content-Type', 'text/html'
      res.end views.index

    app.get '/logs/view', (req, res) ->
      res.statusCode = 200
      res.setHeader 'Content-Type', 'text/html'
      if not (req.query.start || req.query.end)
        res.end '<strong>No start or end date provided</strong>'
      m_start = parseInt(req.query.start)
      m_end   = parseInt(req.query.end)
      if isNaN(m_start) or isNaN(m_end)
        res.end "Invalid range"
        return
      m_start = moment.unix m_start
      m_end   = moment.unix m_end
      room = req.query.room || 'general'
      get_logs_for_range client, m_start, m_end, room, (replies) ->
        res.write views.log_view.head
        res.write format_logs_for_html(replies).join("\r\n")
        res.end views.log_view.tail

    app.get '/logs/:room', (req, res) ->
      res.statusCode = 200
      res.setHeader 'Content-Type', 'text/html'
      res.write views.log_view.head
      res.write "<h2>Logs for #{req.params.room}</h2>\r\n"
      res.write "<ul>\r\n"

      # This is a bit of a hack... KEYS takes O(n) time
      # and shouldn't be used for this, but it's not worth
      # creating a set just so that we can list all logs 
      # for a room.
      client.keys "logs:#{req.params.room}:*", (err, replies) ->
        for key in replies
          key = key.slice key.lastIndexOf(':')+1, key.length
          res.write "<li><a href=\"/logs/#{req.params.room}/#{key}\">#{key}</a></li>\r\n"
        res.write "</ul>"
        res.end views.log_view.tail

    app.get '/logs/:room/:id', (req, res) ->
      res.statusCode = 200
      res.setHeader 'Content-Type', 'text/html'
      id = parseInt req.params.id
      if isNaN(id)
        res.end "Bad log ID"
        return
      get_log client, req.params.room, id, (logs) ->
        res.write views.log_view.head
        res.write format_logs_for_html(logs).join("\r\n")
        res.end views.log_view.tail

  robot.log_server = connect.listen process.env.LOG_HTTP_PORT || 8081

  ####################
  ## Chat interface ##
  ####################

  # When we join a room, wait for some activity and notify that we're logging chat
  # unless we're in stealth mode
  robot.hear /.*/, (msg) ->
    return if process.env.LOG_STEALTH
    return if msg.match[0] == "#{robot.name} start logging"
    return if msg.match[0] == "#{robot.name} stop logging"
    if not (robot.logging[msg.message.user.room]?.notified && robot.brain.data
                                                              .logging[msg.message.user.room]
                                                              ?.enabled)
      msg.send "I'm logging messages in #{msg.message.user.room} at " +
                 "http://#{OS.hostname()}:#{process.env.LOG_HTTP_PORT || 8081}/" +
                 "logs/#{msg.message.user.room}/#{date_id()}\n" +
                 "Say `#{robot.name} stop logging forever' to disable logging indefinitely."
      robot.logging[msg.message.user.room] = { notified: true }

  # Enable logging
  robot.respond /start logging( messages)?$/i, (msg) ->
    enable_logging robot, client, msg

  # Disable logging with various options
  robot.respond /stop logging( messages)?$/i, (msg) ->
    end = moment().add('minutes', 15)
    disable_logging robot, client, msg, end

  robot.respond /stop logging forever$/i, (msg) ->
    disable_logging robot, client, msg, 0

  robot.hear /requests? the cone of silence/i, (msg) ->
    end = moment().add('minutes', 15)
    disable_logging robot, client, msg, end

  robot.respond /stop logging( messages)? for( the next)? ([0-9]+) (seconds?|minutes?|hours?)$/i, (msg) ->
    num = parseInt msg.match[3]
    return if isNaN(num)
    end = moment().add(msg.match[4][0], num)
    disable_logging robot, client, msg, end

  # PM logs to people who request them
  robot.respond /(message|send) me (all|the|today'?s) logs?$/i, (msg) ->
    get_logs_for_day client, new Date(), msg.message.user.room, (logs) ->
      if logs.length == 0
        msg.reply "I don't have any logs saved for today."
        return

      logs_formatted = format_logs_for_chat(logs)
      robot.send direct_user(msg.message.user.id, msg.message.user.room), logs_formatted.join("\n")

  robot.respond /what did I miss\??$/i, (msg) ->
    now = moment()
    before = moment().subtract('m', 10)
    get_logs_for_range client, before, now, msg.message.user.room, (logs) ->
      logs_formatted = format_logs_for_chat(logs)
      robot.send direct_user(msg.message.user.id, msg.message.user.room), logs_formatted.join("\n")

  robot.respond /what did I miss in the [pl]ast ([0-9]+) (seconds?|minutes?|hours?)\??/i, (msg) ->
    num = parseInt(msg.match[1])
    if isNaN(num)
      msg.reply "I'm not sure how much time #{msg.match[1]} #{msg.match[2]} refers to."
      return
    now   = moment()
    start = moment().subtract(msg.match[2][0], num)

    if now.diff(start, 'days', true) > 1
      robot.send direct_user(msg.message.user.id, msg.message.user.room),
                 "I can only tell you activity for the last 24 hours in a message."
      start = now.sod().subtract('d', 1)

    get_logs_for_range client, start, moment(), msg.message.user.room, (logs) ->
      logs_formatted = format_logs_for_chat(logs)
      robot.send direct_user(msg.message.user.id, msg.message.user.room), logs_formatted.join("\n")


## Logging helpers
# Converts date into a string formatted YYYYMMDD
date_id = (date=moment())->
  date = moment(date) if date instanceof Date
  return date.format("YYYYMMDD")

# Returns an array of date IDs for the range between
# start and end (inclusive)
enumerate_keys_for_date_range = (start, end) ->
  ids = []
  start = moment(start) if start instanceof Date
  end = moment(end) if end instanceof Date
  start_i = moment(start)
  while end.diff(start_i, 'days', true) >= 0
    ids.push date_id(start_i)
    start_i.add 'days', 1
  return ids

# Returns an array of pretty-printed log messages for <logs>
# Params:
#   logs - an array of log objects
format_logs_for_chat = (logs) ->
  formatted = []
  logs.forEach (item) ->
    entry = JSON.parse item
    timestamp = moment(entry.timestamp)
    str = timestamp.format("MMM DD YYYY HH:mm:ss")

    if entry.type is 'join'
      str += " #{entry.from} joined"
    else if entry.type is 'part'
      str += " #{entry.from} left"
    else
      str += " <#{entry.from}> #{entry.message}"
    formatted.push str
  return formatted

# Returns an array of lines representing a table for <logs>
# Params:
#   logs - an array of log objects
format_logs_for_html = (logs) ->
  lines = ["<table>"]
  for log in logs
    l = JSON.parse log
    l.time = moment(l.timestamp).format("YYYY-MM-DD HH:mm:ss")
    switch l.type
      when 'join'
        lines.push "<tr><td style=\"border-right: solid 15px transparent;\">" +
                   "#{l.time}</td><td>#{l.from} joined</td></tr>"
      when 'part'
        lines.push "<tr><td style=\"border-right: solid 15px transparent;\">" +
                   "#{l.time}</td><td>#{l.from} left</td></tr>"
      when 'text'
        lines.push "<tr><td style=\"border-right: solid 15px transparent;\">" +
                   "#{l.time}</td><td>&lt;#{l.from}&gt; #{l.message}</td></tr>"
  lines.push "</table>"
  return lines

# Returns a User object to send a direct message to
# Params:
#   id   - the user's adapter ID
#   room - string representing the room the user is in (optional for some adapters)
direct_user = (id, room=null) ->
  u =
    type: 'direct'
    id: id
    room: room

# Calls back an array of JSON log objects representing the log
# for the given ID
# Params:
#   redis - a Redis client object
#   room  - the room to look up logs for
#   id    - the date to look up logs for
#   callback - a function that takes an array
get_log = (redis, room, id, callback) ->
  log_key = "logs:#{room}:#{id}"
  return [] if not redis.exists log_key
  redis.lrange [log_key, 0, -1], (err, replies) ->
    callback(replies)

# Calls back an array of JSON log objects representing the log
# for every date ID in <ids>
# Params:
#   redis - a Redis client object
#   room  - the room to look up logs for
#   ids   - an array of YYYYMMDD date id strings to pull logs for
#   callback - a function taking an array of log objects
get_logs_for_array = (redis, room, ids, callback) ->
  m = redis.multi()
  for id in ids
    m.lrange("logs:#{room}:#{id}", 0, -1)
  m.exec (err, reply) ->
    ret = []
    if reply[0] instanceof Array
      for r in reply
        ret = ret.concat r
    else
      ret = reply
    callback(ret)

# Calls back an array of JSON log objects representing the log
# for <date>
# Params:
#   redis - a Redis client object
#   date  - Date or Moment object representing the date to look up
#   room  - the room to look up 
#   callback - function to pass an array of log objects for date to
get_logs_for_day = (redis, date, room, callback) ->
  get_log redis, room, date_id(date), (reply) ->
    callback(reply)

# Calls back an array of JSON log objects representing the log
# between <start> and <end>
# Params:
#   redis  - a Redis client object
#   start  - Date or Moment object representing the start of the range
#   end    - Date or Moment object representing the end of the range (inclusive)
#   room   - the room to look up logs for
#   callback - a function taking an array as an argument
get_logs_for_range = (redis, start, end, room, callback) ->
  get_logs_for_array redis, room, enumerate_keys_for_date_range(start, end), (logs) ->
    # TODO: use a fuzzy binary search to find the start and end indices
    # of the log entries we want instead of iterating through the whole thing
    slice = []
    for log in logs
      e = JSON.parse log
      slice.push log if e.timestamp >= start.valueOf() && e.timestamp <= end.valueOf()
    callback(slice)

# Enables logging for the room that sent response
# Params:
#   robot - a Robot instance
#   redis - a Redis client object
#   response - a Response that can be replied to
enable_logging = (robot, redis, response) ->
  if robot.brain.data.logging[response.message.user.room]?.enabled
    response.reply "Logging is already enabled."
    return
  robot.brain.data.logging[response.message.user.room] ||= {}
  robot.brain.data.logging[response.message.user.room].enabled = true
  robot.brain.data.logging[response.message.user.room].pause = null
  log_entry(redis, new Entry(robot.name, Date.now(), 'text',
            "#{response.message.user.name || response.message.user.id} restarted logging."),
            response.message.user.room)

  response.reply "I will log messages in #{response.message.user.room} at " +
                 "http://#{OS.hostname()}:#{process.env.LOG_HTTP_PORT || 8081}/" +
                 "logs/#{response.message.user.room}/#{date_id()} from now on.\n" +
                 "Say `#{robot.name} stop logging forever' to disable logging indefinitely."
  robot.brain.save()

# Disables logging for the room that sent response
# Params:
#   robot - a Robot instance
#   redis - a Redis client object
#   response - a Response that can be replied to
#   end - a Moment representing the time at which to start logging again, or
#       - a number representing the number of milliseconds until logging should be resumed, or
#       - 0 or undefined to disable logging indefinitely
disable_logging = (robot, redis, response, end=0) ->
  if robot.brain.data.logging[response.message.user.room]?.enabled == false
    if robot.brain.data.logging.pause
      pause = robot.brain.data.logging.pause
      response.reply "Logging was already disabled #{pause.time.fromNow()} by " +
                     "#{pause.user} until #{pause.end.format()}."
      return
    else
      response.reply "Logging is currently disabled."
      return
  robot.brain.data.logging[response.message.user.room] ||= {}
  robot.brain.data.logging[response.message.user.room].enabled = false
  if end != 0
    if not end instanceof moment
      if end instanceof Date
        end = moment(end)
      else
        end = moment().add('seconds', parseInt(end))
    robot.brain.data.logging.pause =
      time: moment()
      user: response.message.user.name || response.message.user.id || 'unknown'
      end: end
    log_entry(redis, new Entry(robot.name, Date.now(), 'text',
              "#{response.message.user.name || response.message.user.id} disabled logging" +
              " until #{end.format()}."), response.message.user.room)

    # Re-enable logging after the set amount of time
    setTimeout (-> enable_logging(robot, redis, response) if not robot.brain.data
                                                                  .logging[response.message.user.room]
                                                                  .enabled),
                  end.diff(moment())
    response.reply "OK, I'll stop logging until #{end.format()}."
    robot.brain.save()
    return
  log_entry(redis, new Entry(robot.name, Date.now(), 'text',
            "#{response.message.user.name || response.message.user.id} disabled logging indefinitely."), 
            response.message.user.room)

  robot.brain.save()
  msg.reply "OK, I'll stop logging from now on."

# Logs an Entry object
# Params:
#   redis - a Redis client instance
#   entry - an Entry object to log
#   room  - the room to log it in
log_entry = (redis, entry, room='general') ->
  if not entry.type && entry.timestamp
    throw new Error("Argument #{entry} to log_entry is not an entry object")
  entry = JSON.stringify entry
  redis.rpush("logs:#{room}:#{date_id()}", entry)

# Listener callback to log message in redis
# Params:
#   redis - a Redis client instance
#   response - a Response object emitted from a Listener
log_message = (redis, robot, response) ->
  return if not robot.brain.data.logging[response.message.user.room]?.enabled
  if response.message instanceof hubot.TextMessage
    type = 'text'
  else if response.message instanceof hubot.EnterMessage
    type = 'join'
  else if response.message instanceof hubot.LeaveMessage
    type = 'part'
  return if process.env.LOG_MESSAGES_ONLY && type != 'text'
  entry = JSON.stringify(new Entry(response.message.user?['id'], Date.now(), type, response.message.text))
  room = response.message.user.room || 'general'
  redis.rpush("logs:#{room}:#{date_id()}", entry)


## Views for the Connect server
views =
  index: """
    <!DOCTYPE html>
    <html>
      <head>
        <title>View logs</title>
      </head>
      <body>
        <div>
          <form action="/logs/view" method="get">
            <label for="room">JID of room</label>
            <input name="room" type="text" placeholder="chatroom@conference.jabber.example.com"><br />
            <label for="start">UNIX timestamp for start date</label>
            <input name="start" type="text" placeholder="1234567890" /><br />
            <label for="end">End date</label>
            <input name="end" type="text" placeholder="1234567890" /><br />
            <input type="submit" value="Submit" />
          </form>
        </div>
      </body>
    </html>"""
  log_view:
    head: """
      <!DOCTYPE html>
      <html>
        <head>
          <title>Viewing logs</title>
        </head>
        <body>
          <div style="font-family: Consolas, Inconsolata, Courier New, monospace;">
        """
    tail: "</div></body></html>"

