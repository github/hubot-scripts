# Description:
#  Deployment information to your room
#
# Dependencies:
#   "querystring": "0.1.0"
#
# Configuration:
#   HUBOT_DEPLOY_ROOM - room to send announcements to
#
# Commands:
#   None
#
# URLs:
#   GET /hubot/deploy?environment=<environment>&project=<project>[&version=<version>]
#
# Authors:
#   jslagle
#
# Roughly based on http-say by ajacksified

qs = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/deploy", (req, res) ->
    query = qs.parse(req._parsedUrl.query)
    environment = query.environment
    project = query.project
    version = query.version if query.version

    user = {}
    user.room = process.env.HUBOT_DEPLOY_ROOM

    message = "DEPLOY: " + project + " was deployed to " + environment
    message += " version " + version if version

    robot.send(user, message)
    if robot.adapter.bot?
      robot.adapter.bot.Room(user.room).sound "trombone", (err, data) =>
        console.log "campfire error: #{err}" if err

    res.end "Deploy sent"



