# Description:
#   STOP! Hammertime.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   stop - it's hammertime.
#
# Author:
#   @shaundon

module.exports = (robot) ->
  robot.hear /stop/i, (msg) ->
    msg.send "Hammertime."
