# Description:
#   Fetches graylog messages via Hubot
#
# Dependencies:
#   None
#
# Configuration
#   GRAYLOG_URL (e.g. https://graylog.example.com)
#   GRAYLOG_API_TOKEN (e.g. 098f6bcd4621d373cade4e832627b4f6)
#   GRAYLOG_SEPARATOR (e.g. ','. Default: "\n")
#
# Commands:
#   hubot graylog - output last 5 graylog messages
#   hubot graylog <count> - output last <count> graylog messages
#   hubot graylog streams - list graylog streams
#   hubot graylog hosts - list graylog hosts
#   hubot graylog <stream> <count> - output some messages from given stream
#   hubot graylog host <host> <count> - output some messages from given host
#
# Notes
#   Output format: "[timestamp] message content"
#
# Author:
#   spajus

module.exports = (robot) ->

  robot.respond /graylog streams$/i, (msg) ->
    graylogStreams msg, (what) ->
      msg.send what

  robot.respond /graylog hosts$/i, (msg) ->
    graylogHosts msg, (what) ->
      msg.send what

  robot.respond /graylog$/i, (msg) ->
    graylogStreamMessages msg, 'all', 5, (what) ->
      msg.send what

  robot.respond /graylog (\d+)$/i, (msg) ->
    count = parseInt(msg.match[1] || '5')
    graylogMessages msg, 'messages.json', (messages) ->
      sayMessages messages, count, (what) ->
        msg.send what

  robot.respond /graylog (.+) (\d+)/i, (msg) ->
    stream = msg.match[1]
    count = parseInt(msg.match[2] || '5')
    graylogStreamMessages msg, stream, count, (what) ->
      msg.send what

  robot.respond /graylog host (.+) (\d+)/i, (msg) ->
    host = msg.match[1]
    count = parseInt(msg.match[2] || '5')
    graylogHostMessages msg, host, count, (what) ->
      msg.send what

graylogStreamMessages = (msg, stream_title, count, cb) ->
  if stream_title == 'all'
    graylogMessages msg, 'messages.json', (messages) ->
      sayMessages messages, count, cb
  else
    graylogStreamList msg, (streams) ->
      for stream in streams
        if stream.title == stream_title
          url = "streams/#{stream._id}-#{stream.title}/messages.json"
          graylogMessages msg, url, (messages) ->
            sayMessages messages, count, cb
          return

graylogHostMessages = (msg, host_name, count, cb) ->
  url = "hosts/#{host_name}/messages.json"
  graylogMessages msg, url, (messages) ->
    sayMessages messages, count, cb

graylogMessages = (msg, url, cb) ->
  graylogList msg, url, cb

sayMessages = (messages, count, cb) ->
  said = 0
  for message in messages
    said += 1
    cb "[#{message.histogram_time}] #{message.message}"
    return if said >= count or said == 20
  if said < 1
    cb "No graylog messages"

graylogUrl = (path) ->
  "#{process.env.GRAYLOG_URL}/#{path}?api_key=#{process.env.GRAYLOG_API_TOKEN}"

separator = ->
  process.env.GRAYLOG_SEPARATOR || "\n"

graylogStreams = (msg, cb) ->
  graylogStreamList msg, (streams) ->
    stream_titles = []
    for stream in streams
      stream_titles.push stream.title
    cb "Graylog streams: #{stream_titles.join(separator())}"

graylogStreamList = (msg, cb) ->
  graylogList msg, 'streams.json', cb

graylogHostList = (msg, cb) ->
  graylogList msg, 'hosts.json', cb

graylogList = (msg, url, cb) ->
  url = graylogUrl url
  msg.robot.http(url).get() (err, res, body) ->
    unless res.statusCode is 200
      console.log 'Error requesting Graylog url', url, body
      return
    cb JSON.parse body

graylogHosts = (msg, cb) ->
  graylogHostList msg, (hosts) ->
    host_names = []
    for host in hosts
      host_names.push "#{host.host} (#{host.message_count})"
    cb "Graylog hosts: #{host_names.join(separator())}"

