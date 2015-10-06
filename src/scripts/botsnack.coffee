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
#   botsnack - give the bot a food
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
  robot.hear /botsnack/i,{id: 'botsnack.feed'}, (msg) ->
    msg.send msg.random responses
