# Description:
#   Displays odds out of 100 when "odds of" or "chances of" is heard
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <odds of> - Displays odds out of 100
#   <the chances> - Displays odds out of 100
#
# Author:
#   stublag

module.exports = (robot) ->
  robot.hear /\b(chances|odds) of\b|\bthe (chances|odds)\b/i, (msg) ->
    odds = Math.floor(Math.random() * 100) + " in 100"
    msg.send odds
