# Description:
#   Hodor
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hodor - Hodor
#
# Author:
#   crcastle

module.exports = (robot) ->
  robot.respond /hodor/i, (msg) ->
    msg.send "Hodor"
