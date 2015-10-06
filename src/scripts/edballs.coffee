# Description:
#   Ed Balls
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Ed Balls - Ed Balls
#
# Author:
#   @pikesley

module.exports = (robot) ->
  robot.hear /Ed Balls/i,{id: 'ed.balls'}, (msg) ->
    msg.send "Ed Balls"
