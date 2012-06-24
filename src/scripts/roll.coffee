# Description:
#   Roll a dice!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot roll - Generates a random number between 1 and 100 inclusive
#   hubot roll <num> - Generates a random number between 1 and <num> inclusive
#   hubot roll <num>-<num2> - Generates a random number between <num> and <num2> inclusive
#
# Author:
#   jkongie

module.exports = (robot) ->
  robot.respond /(roll)\s?(\d+)?-?(\d+)?/i, (msg) ->
    low  = 1
    high = 100

    if msg.match[3] == undefined && msg.match[2]
      high = parseInt(msg.match[2])
    else if msg.match[2] && msg.match[3]
      low  = parseInt(msg.match[2])
      high = parseInt(msg.match[3])

    rand = Math.floor(Math.random() * (high - low + 1)) + low
    msg.reply "rolled a #{rand} of #{high}"
