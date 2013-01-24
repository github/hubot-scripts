# Description:
#   Send messages using the Hipchat API (which allows you to choose colors
#   and send html messages) instead of the plain old jabber interface
#
# Dependencies:
#   "querystring": "0.1.0"
#
# Configuration:
#   HUBOT_HIPCHAT_TOKEN - Hipchat API token
#
# Commands:
#   None
#
# URLs:
#   GET /hubot/hipchat?room_id=<room_id>&message=<message>&from=<from>[&color=<red/yellow/green/gray/purple/random>&notify=<true/false>&message_format=<html/text>]
#
# Author:
#   mcdavis

querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/hipchat", (req, res) ->
    https = require 'https'
    query = querystring.parse(req._parsedUrl.query)

    hipchat = {}
    hipchat.format = 'json'
    hipchat.auth_token = process.env.HUBOT_HIPCHAT_TOKEN

    hipchat.room_id = query.room_id if query.room_id
    hipchat.message = query.message if query.message
    hipchat.from = query.from if query.from
    hipchat.color = query.color if query.color
    hipchat.notify = query.notify if query.notify
    hipchat.message_format = query.message_format if query.message_format

    params = querystring.stringify(hipchat)

    path = "/v1/rooms/message/?#{params}"

    data = ''

    callback = ->
        res.end data

    https.get {host: 'api.hipchat.com', path: path}, (res) ->
        res.on 'data', (chunk) ->
            data += chunk.toString()
        res.on 'end', () ->
            json = JSON.parse(data)
            console.log "Hipchat response ", data
            callback()

