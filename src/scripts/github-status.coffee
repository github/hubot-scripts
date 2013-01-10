# Description:
#   Show current GitHub status and messages
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot github status - Returns the current system status and timestamp.
#   hubot github status last - Returns the last human communication, status, and timestamp.
#   hubot github status messages - Returns the most recent human communications with status and timestamp.
#
# Author:
#   voke

module.exports = (robot) ->
  robot.respond /github status$/i, (msg) ->
    status msg

  robot.respond /github status last$/i, (msg) ->
    lastMessage msg

  robot.respond /github status messages$/i, (msg) ->
    statusMessages msg

# NOTE: messages contains new lines for some reason.
formatString = (string) ->
  decodeURIComponent(string.replace(/(\n)/gm," "))

status = (msg) ->
  msg.http('https://status.github.com/api/status.json')
    .get() (err, res, body) ->
      json = JSON.parse(body)
      now = new Date()
      date = new Date(json['last_updated'])
      secondsAgo = Math.round((now.getTime() - date.getTime()) / 1000)
      msg.send "Status: #{json['status']} (#{secondsAgo} seconds ago)"

lastMessage = (msg) ->
  msg.http('https://status.github.com/api/last-message.json')
    .get() (err, res, body) ->
      json = JSON.parse(body)
      date = new Date(json['created_on'])
      msg.send "Status: #{json['status']}\n" +
               "Message: #{formatString(json['body'])}\n" +
               "Date: #{date.toLocaleString()}"

statusMessages = (msg) ->
  msg.http('https://status.github.com/api/messages.json')
    .get() (err, res, body) ->
      json = JSON.parse(body)
      buildMessage = (message) ->
        date = new Date(message['created_on'])
        "[#{message['status']}] #{formatString(message['body'])} (#{date.toLocaleString()})"
      msg.send (buildMessage message for message in json).join('\n')
