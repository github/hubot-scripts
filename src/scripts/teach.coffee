# Description
#   Hubot teaches you random facts
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot teach
#    
# Notes:
#   None
#
# Author:
#   Minh-Tue Vo

module.exports = (robot) ->

  robot.respond /teach/i, (msg) ->
    msg.http("http://www.randomfunfacts.com")
      .get() (err, res, body) ->
        msg.send body.match(/\<i\>(.*)\<\/i\>/)[1]
        