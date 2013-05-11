# Description:
#   Is it the day?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot is it <action> day ? - Returns if it's the day for your action
#
# Author:
#   KuiKui
             
module.exports = (robot) ->
  robot.respond /is it (\w+) day ?\?/i, (msg) ->
    action = msg.match[1]
    nbDay = Math.floor(new Date().getTime() / 1000 / 86400)
    actionHash = action.length + action.charCodeAt(0) + action.charCodeAt(action.length - 1)
    destiny = Math.cos(nbDay + actionHash) + 1
    limit = (Math.sin(actionHash) + 1) / 2
    if destiny > limit
      msg.send "Sorry, it's not " + action + " day. But try tomorrow..."
    else
      msg.send "Yes, it's " + action + " day !"
