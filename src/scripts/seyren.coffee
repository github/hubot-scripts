# Description:
#   Allows Hubot to chat about Seyren.
#   Seyren can be found here: https://github.com/scobal/seyren
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   neilprosser

QS = require "querystring"
module.exports = (robot) ->

  robot.router.post "/hubot/seyren/alert", (req, res) ->
    seyrenUrl = req.body.seyrenUrl
    rooms = req.body.rooms
    check = req.body.check
    alerts = req.body.alerts
    res.end "Thanks for letting me know"

    message = "Seyren is saying that #{check.name} changed state:\n"

    for alert in alerts
      message += "- #{alert.target} has gone from #{alert.fromType} to #{alert.toType} with #{alert.value}\n"

    message += "The warning value is #{check.warn} and the error value is #{check.error}.\n"
    message += "#{seyrenUrl}/#/checks/#{check.id}"

    for room in rooms
      robot.messageRoom room, message