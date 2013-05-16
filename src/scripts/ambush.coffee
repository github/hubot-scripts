# Description:
#   Send messages to users the next time they speak
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ambush <user name>: <message>
#
# Author:
#   jmoses

appendAmbush = (data, toUser, fromUser, message) ->
  data[toUser.name] or= []
  
  data[toUser.name].push [fromUser.name, message]
  
module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.ambushes ||= {}

  robot.respond /ambush (.*?): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    if users.length is 1
      user = users[0]
      appendAmbush(robot.brain.data.ambushes, user, msg.message.user, msg.match[2])
      msg.send "Ambush prepared"
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{msg.match[1]}? Never heard of 'em"
  
  robot.hear /./i, (msg) ->
    return unless robot.brain.data.ambushes?
    if (ambushes = robot.brain.data.ambushes[msg.message.user.name])
      msg.send "Hey, " + msg.message.user.name + ", while you were out:"
      for ambush in ambushes
        msg.send ambush[0] + " says: " + ambush[1]
      msg.send "That's it. You were greatly missed."
      delete robot.brain.data.ambushes[msg.message.user.name]
