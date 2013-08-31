# Description:
#   Get a random commit message
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot commit message - Displays a random commit message
#
# Author:
#   mrtazz
#
# Tags:
#   fun

module.exports = (robot) ->
  robot.respond /commit message/i, (msg) ->
    msg.http("http://whatthecommit.com/index.txt")
       .get() (err, res, body) ->
         msg.reply body
