# Description:
#   "Simple path to have Hubot echo out anything in the message querystring for a given room."
#
# Dependencies:
#   "querystring": "0.1.0"
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLs:
#   GET /hubot/say?message=<message>[&room=<room>&type=<type>]
#
# Author:
#   ajacksified

querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/say", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    envelope = {}
    envelope.user = {}
    envelope.user.room = envelope.room = query.room if query.room
    envelope.user.type = query.type or 'groupchat'

    robot.send envelope, query.message

    res.end "Said #{query.message}"
