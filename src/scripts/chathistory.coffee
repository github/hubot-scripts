# Description
#   Stores the command history for each user , by default stores last 5 commands sent .
#   Chat history for a user can be accessed from "msg.message.user.historychat" 
#
# Dependencies:
#   node
#
# Configuration:
#   HUBOT_USER_HISTORY_LINES : Number of lines of history to store
#
# Commands:
#   chathistory clear : Clears the users chat history
#   chathistory last command : return the last command used by the user
#
# Notes:
#   Its not similar to history module , it should be used when you need ID specific history
#
# Author:
#   nautical


module.exports = (robot) ->

  options =
    lines_to_keep: process.env.HUBOT_USER_HISTORY_LINES

  unless options.lines_to_keep
    options.lines_to_keep = 5

  robot.hear /(.*)/i, (msg) ->
    console.log msg.match[1]
    userhistory = []
    userhistory = msg.message.user.historychat
    if userhistory == undefined
        userhistory = []
    if userhistory.length < options.lines_to_keep
        userhistory.push msg.match[1]
        msg.message.user.historychat = userhistory
        robot.brain.data.users[msg.message.user.id] = msg.message.user
    else
        userhistory.shift()
        userhistory.push msg.match[1]
        msg.message.user.historychat = userhistory
        robot.brain.data.users[msg.message.user.id] = msg.message.user

  robot.respond /chathistory clear/i, (msg) ->
    msg.send "Ok, I'm clearing your history."
    userhistory = []
    msg.message.user.historychat = userhistory
    robot.brain.data.users[msg.message.user.id] = msg.message.user
    
  robot.respond /chathistory last command/i, (msg) ->
    msg.send msg.message.user.historychat[msg.message.user.historychat.length-2] # not -1 , it will return "last command" only