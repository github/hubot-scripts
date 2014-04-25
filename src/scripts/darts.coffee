# Description
#   Fires foam darts at your colleagues
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot shoot <target's gravatar email> - Fire's a foam dart at the target
#
# Notes:
#   None
#
# Author:
#   bsensale

module.exports = (robot) ->

  robot.respond /shoot (\w*)\s?(in the)?\s?(head|body|legs)?/i, (msg) ->
    victim = robot.brain.userForName(msg.match[1]) 
    if not victim
      msg.reply "You want me to shoot someone who doesn't exist.  You are strange."
      return
    aim = msg.match[3]
    if not aim
      aim = msg.random ["head", "body", "legs"]
    target = msg.random ["#{aim}", "#{aim}", "#{aim}", "miss"]

    result = (target) ->
      if target is "miss"
        "The shot sails safely overhead."
      else if target is "head"
        msg.random [
          "It hits #{victim} right in the eye!  You monster!",
          "It bounces right off #{victim}'s nose.",
          "It hits #{victim} in the ear.  Why would you do that?",
          "POW!  BANG!  #{victim} is hit right in the kisser!",
          "Right in the temple.  #{victim} falls limp to the floor."
        ]
      else if target is "body"
        msg.random [
          "The shot bounces off #{victim}'s shoulder",
          "It hits #{victim} right in the chest.  #{victim} has trouble drawing their next breath.",
          "The dart hits #{victim} in the stomach and gets lodged in their belly button.",
          "It hits #{victim} in the back, causng temporary paralysis.",
          "The dart bounce's off #{victim}'s left shoulder, spinning them violently around."
        ]
      else if target is "legs"
        msg.random [
          "The dart smacks into #{victim}'s thigh.  Charlie Horse!!!",
          "The dart hits #{victim} square in the crotch.  I need an adult!",
          "It hits #{victim} right in the kneecap.  What did they owe you money?",
          "It smacks into #{victim}'s pinkie toe.  They go wee wee wee all the way home!",
          "The dart hits right on #{victim}'s shin, knocking them to the ground"
        ]

    msg.emote "fires a foam dart at #{victim}'s #{aim}.  #{result target}"
    msg.send msg.random hit
