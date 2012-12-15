# Description:
#   Bees are insane
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bees - Oprah at her finest, or a good way to turn the fans on coworkers machines
#
# Author:
#   atmos

module.exports = (robot) ->
  robot.respond /bees/i, (message) ->
    message.send "http://i.imgur.com/qrLEV.gif"
