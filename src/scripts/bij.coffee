# Description:
#   EXPERIENCE BIJ
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   mrtazz

module.exports = (robot) ->
  robot.hear /bij/i, (msg) ->
    msg.send "EXPERIENCE BIJ!"
