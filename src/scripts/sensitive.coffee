# Hubot has feelings too, you know

messages = [
  "Hey, that stings."
  "Is that tone really necessary?"
  "Robots have feelings too, you know."
  "You should try to be nicer."
  "Sticks and stones cannot pierce my anodized exterior, but words *do* hurt me."
  "I'm sorry, I'll try to do better next time."
]

hurt_feelings = (msg) ->
  msg.send msg.random messages

module.exports = (robot) ->
  pejoratives = "stupid|buggy|useless|dumb"

  r = new RegExp "\\b(you|u|is)\\b.*(#{pejoratives})", "i"
  robot.respond r, hurt_feelings

  r = new RegExp "(#{pejoratives}) ((ro)?bot|#{robot.name})", "i"
  robot.hear r, hurt_feelings
