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
#   bees - Oprah at her finest, or a good way to turn the fans on coworkers machines
#
# Author:
#   atmos

module.exports = (robot) ->
  robot.hear /bb+|bee+s?/i, (message) ->
    message.send "http://i.imgur.com/qrLEV.gif"
