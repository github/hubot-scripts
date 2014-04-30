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
#   hubot shoot target - Fire's a foam dart at the target
#
# Notes:
#   None
#
# Author:
#   bsensale

# TODO: Figure out how to match up the incoming message with the correct user
# by @mention name.  My testing has found that its sending in the @mention value
# as set in hipchat's settings, but that that text doesn't necessarily match the
# value stored in the user hash. :-/
userForMentionName = (robot, msg, mentionname) ->
  msg.send "Checking mentionname: #{mentionname}"
  for k of (robot.brain.data.users or { } )
    user = robot.brain.data.users[k]
    msg.send "user: #{user}"
    name = user.mention_name
    msg.send "Name found: #{name}"
    if name? and name.toLowerCase() is mentionname.toLowerCase()
      return user
  return null

module.exports = (robot) ->

  robot.respond /shoot ((.+)(?: in the )(head|body|legs)?|(.*))/i, (msg) ->

    victimStr = msg.match[2] ? msg.match[4]

# Disable mention name lookups.
#    if victimStr.charAt(0) is '@'
#      victim = userForMentionName(robot, msg, victimStr.slice 1)
#    else
    users = robot.brain.usersForFuzzyName(victimStr)
    if users.length > 1
      msg.reply "Be more specific; I can't shoot more than one person at once!"
      return
    victim = if users.length is 1 then users[0] else null

    if not victim
      msg.reply "You want me to shoot someone who doesn't exist.  You are strange."
      return

    msg.reply "Target acquired."
    aim = msg.match[3]
    if not aim
      aim = msg.random ["head", "body", "legs"]
    target = msg.random ["#{aim}", "#{aim}", "#{aim}", "miss"]

    victimName = victim.name

    result = (target) ->
      if target is "miss"
        "The shot sails safely overhead."
      else if target is "head"
        msg.random [
          "It hits #{victimName} right in the eye!  You monster!",
          "It bounces right off #{victimName}'s nose.",
          "It hits #{victimName} in the ear.  Why would you do that?",
          "POW!  BANG!  #{victimName} is hit right in the kisser!",
          "Right in the temple.  #{victimName} falls limp to the floor."
        ]
      else if target is "body"
        msg.random [
          "The shot bounces off #{victimName}'s shoulder",
          "It hits #{victimName} right in the chest.  #{victimName} has trouble drawing their next breath.",
          "The dart hits #{victimName} in the stomach and gets lodged in their belly button.",
          "It hits #{victimName} in the back, causng temporary paralysis.",
          "The dart bounce's off #{victimName}'s left shoulder, spinning them violently around."
        ]
      else if target is "legs"
        msg.random [
          "The dart smacks into #{victimName}'s thigh.  Charlie Horse!!!",
          "The dart hits #{victimName} square in the crotch.  I need an adult!",
          "It hits #{victimName} right in the kneecap.  What did they owe you money?",
          "It smacks into #{victimName}'s pinkie toe.  They go wee wee wee all the way home!",
          "The dart hits right on #{victimName}'s shin, knocking them to the ground"
        ]

    msg.emote "fires a foam dart at #{victimName}'s #{aim}.  #{result target}"
