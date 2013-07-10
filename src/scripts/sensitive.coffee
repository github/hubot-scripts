# Description:
#   Hubot has feelings too, you know
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
#   iangreenleaf

messages = [
  "Hey, that stings."
  "Is that tone really necessary?"
  "Robots have feelings too, you know."
  "You should try to be nicer."
  "Sticks and stones cannot pierce my anodized exterior, but words *do* hurt me."
  "I'm sorry, I'll try to do better next time."
  "https://p.twimg.com/AoTI6tLCIAAITfB.jpg"
]

hurt_feelings = (msg) ->
  msg.send msg.random messages

module.exports = (robot) ->
  pejoratives = "stupid|buggy|useless|dumb|suck|crap|shitty|idiot"

  r = new RegExp "\\b(you|u|is)\\b.*(#{pejoratives})", "i"
  robot.respond r, hurt_feelings

  r = new RegExp "(#{pejoratives}) ((ro)?bot|#{robot.name})", "i"
  robot.hear r, hurt_feelings
