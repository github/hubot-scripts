# Description:
#   Set your availability status so people know whether they're able to come
#   over and chat with you or ping you over IM.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot is <user> available - Find out if the specified user is available or not
#   hubot i am <available|free|not busy|at hand> - Set that you are available
#   hubot i am <unavailable|dnd|do not disturb|busy|in the zone> - Setthat you are not available
#
# Author:
#   tombell

module.exports = (robot) ->

  # Find the user by user name from hubot's brain.
  #
  # name - A full or partial name match.
  #
  # Returns a user object if a single user is found, an array of users if more
  # than one user matched the name or false if no user is found.
  findUser = (name) ->
    users = robot.brain.usersForFuzzyName name
    if users.length is 1
      users[0]
    else if users.length > 1
      users
    else
      false


  robot.respond /is (.*) available(\?)?/i, (msg) ->
    name = msg.match[1]
    user = findUser name

    if typeof user is 'object'
      if user.available.available
        msg.send "#{user.name} has been available since #{user.available.timestamp}"
      else
        msg.send "#{user.name} has been unavailable since #{user.available.timestamp}"
    else if typeof user.length > 1
      msg.send "I found #{user.length} people named #{name}"
    else
      msg.send "I have never met #{name}"


  robot.respond /i am (available|free|not busy|at hand)/i, (msg) ->
    name = msg.message.user.name
    user = findUser name

    if typeof user is 'object'
      user.available = available: true, timestamp: new Date
      msg.reply "Okay, I have set you as available"
    else if typeof user.length > 1
      msg.send "I found #{user.length} people named #{name}"
    else
      msg.send "I have never met #{name}"


  robot.respond /i am (unavailable|dnd|do not disturb|busy|in the zone)/i, (msg) ->
    name = msg.message.user.name
    user = findUser name

    if typeof user is 'object'
      user.available = available: false, timestamp: new Date
      msg.reply "Okay, I have set you as unavailable"
    else if typeof user.length > 1
      msg.send "I found #{user.length} people named #{name}"
    else
      msg.send "I have never met #{name}"
