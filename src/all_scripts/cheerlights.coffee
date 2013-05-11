# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cheerlights - get last color from http://www.cheerlights.com
#
# Author:
#   marciotoshio

module.exports = (robot) ->
  robot.respond /cheerlights/i, (msg) ->
   msg.http("http://api.thingspeak.com/channels/1417/field/1/last.json")
    .get() (err, res, body) ->
      response = JSON.parse body
      if response
       msg.send "The last color is: " + response["field1"]
      else
       msg.send "Error"
