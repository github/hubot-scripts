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
  robot.hear /bij/i,{id: 'bij.get'}, (msg) ->
    msg.send "EXPERIENCE BIJ!"
