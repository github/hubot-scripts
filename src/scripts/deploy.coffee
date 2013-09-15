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
#   GET /hubot/deploy?hosts=<hosts>&wars=<wars>[&version=<version>]
#
#   wars is a comma seperated list
#   hosts can also be comma seperated
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
    if robot.adapter.bot?.Room?
      robot.adapter.bot.Room(user.room).sound "trombone", (err, data) =>
        console.log "campfire error: #{err}" if err

    res.end "Deploy sent"


  robot.router.get "/hubot/deployhost", (req, res) ->
    query = qs.parse(req._parsedUrl.query)
    hosts = query.hosts
    wars = query.wars
    version = query.version if query.version

    user = {}
    user.room = process.env.HUBOT_DEPLOY_ROOM
    user.type = "PasteMessage"

    hosta=hosts.split(",")
    wara=wars.split(",")

    if hosta.length == wara.length== 1
      message = "DEPLOY: " + wars + " deployed to " + host
      message += " version " + version if version
    else
      message = "DEPLOY:\n"
      message += " WARS:\n"
      message += "  " + war + "\n" for war in wara
      message += " HOSTS:\n"
      message += "  " + host + "\n" for host in hosta
      message += " VERSION: " + version if version

    robot.send(user, message)

    if robot.adapter.bot?
      robot.adapter.bot.Room(user.room).sound "ohyeah", (err, data) =>
        console.log "campfire error: #{err}" if err

    res.end "Deploy sent"

