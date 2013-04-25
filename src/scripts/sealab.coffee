# Description:
#   Respond to specific phrases with quotes from Sealab 2021
#
# Configuration:
#   None
#
# Commands:
# /(did|can) hubot/ - "Not me! I'm gonna be an Adrienne Barbeau-bot"
# energy - "I have the energy of a bear that has the energy of two bears!"
# bad idea - "Oh why don't you just shout down every idea I have? How about you call Bruce Springsteen and tell him to get another nickname since you're already the Boss! Huh? Yeah? Yeah!"
# change hubot - "You want the mustache on, or off?"
#
# Author:
#   lancepantz

module.exports = (robot) ->

  robot.hear /^(did|can) hubot/i, (msg) ->
    msg.reply "Not me! I'm gonna be an Adrienne Barbeau-bot"

  robot.hear /energy/i, (msg) ->
    msg.reply "I have the energy of a bear that has the energy of two bears!"

  robot.hear /bad idea/i, (msg) ->
    msg.reply "Oh why don't you just shout down every idea I have? How about you call Bruce Springsteen and tell him to get another nickname since you're already the Boss! Huh? Yeah? Yeah!"

  robot.hear /change hubot/i, (msg) ->
    msg.reply "You want the mustache on, or off?"
