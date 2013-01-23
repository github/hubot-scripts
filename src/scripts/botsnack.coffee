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
#   locherm

responses = [
  "Om nom nom!",
  "That's very nice of you!",
  "Oh thx, have a cookie yourself!",
  "Thank you very much.",
  "Thanks for the treat!"
]

module.exports = (robot) ->
  robot.hear /botsnack/i, (msg) ->
    msg.send msg.random responses
