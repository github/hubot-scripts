# Description
#   Hubot gives you a praise for your good works
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot praise
#   hubot praise [username]
#    
# Notes:
#   Everybody deserves praises
#
# Author:
#   MinhVo

module.exports = (robot) ->

  robot.respond /praise (.*)/i, (msg) ->
    person = msg.match[1]
    users = robot.brain.usersForFuzzyName(person)
    message = "Dear #{person}, you are awesome! Get some (beer) and (cake)!"

    if users.length > 1
      msg.send "Sorry, there are too many people who match that name."
    else if users.length < 1
      msg.send message
    else if users.length is 1
      msg.send message
      robot.send user:users[0], message

  robot.respond /praise/i, (msg) ->
    if msg.message.text is "hubot praise"
      msg.send "You are awesome!"