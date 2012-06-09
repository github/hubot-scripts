# Description:
#   Hubot enjoys delicious snacks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   botsnack - give the boot a food
#
# Author:
#   richo

module.exports = (robot) ->
  robot.hear /^botsnack/i, (msg) ->
    msg.send ":D"
