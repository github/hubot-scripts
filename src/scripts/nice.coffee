# Description:
#   Fill your chat with some kindness
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot be nice - just gives some love :)
#
# Author:
#   nesQuick

hugs = [
  "You are awesome!",
  "A laugh is a smile that bursts.",
  "=)",
  "Everyone smiles in the same language.",
  "Thank you for installing me."
]

module.exports = (robot)->
  robot.respond /be nice/i, (message)->
    rnd = Math.floor Math.random() * hugs.length
    message.send hugs[rnd]
