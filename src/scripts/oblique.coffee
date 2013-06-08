# Description:
#   Suggests an oblique strategy
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot strategy - Suggests a strategy
#   hubot a strategy for <user> - Suggests a strategy to user
#
# Notes:
#   You can be as verbose as you want as long as you address Hubot and mention
#   the word strategy and, optionally, one or more users.
#
#   Thanks, Brian Eno.
#
# Author:
#   hakanensari

module.exports = (robot) ->
  robot.respond /.*strategy/i, (msg) ->
    mentions = msg.message.text.match(/(@\w+)/g)
    robot.http('http://oblique.io')
      .get() (err, res, body) ->
        strategy = JSON.parse body
        strategy = "#{mentions.join(', ')}: #{strategy}" if mentions
        msg.send strategy
