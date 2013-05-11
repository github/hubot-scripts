# Description:
#   http://xkcd.com/1009/
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
#   eighnjel

module.exports = (robot) ->
  sigh_counter = 0

  robot.hear /(^|\W)[s]+[i]+[g]+[h]+(\z|\W|$)/i, (msg) ->
    if sigh_counter == 3
      sigh_counter = 0
      msg.send "I work out"
    else
      sigh_counter += 1
      msg.send "Girl look at that body"
