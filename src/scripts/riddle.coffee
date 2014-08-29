# Description
#   Hubot challenges you with a riddle
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot riddle
#   hubot riddle solution
#    
# Notes:
#   None
#
# Author:
#   Minh-Tue Vo

module.exports = (robot) ->

  robot.respond /riddle/i, (msg) ->
    if msg.message.text is "hubot riddle"
      msg.http("http://www.randomriddles.com/")
        .get() (err, res, body) ->
          riddle = body.match(/\<i\>(.*)\<a ; onmousedown=/)[1]
          msg.send riddle
          robot.brain.solution = body.match(/alert\('(.*)'\)/)[1]

  robot.respond /riddle solution/i, (msg) ->
    if robot.brain.solution?
      msg.send robot.brain.solution