# Description:
#   Display GitHub zen message from https://api.github.com/zen API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot zen - Display GitHub zen message
#
# Author:
#   anildigital
#

module.exports = (robot) ->
  robot.hear /zen/i, (msg) ->
    msg
      .http("https://api.github.com/zen")
      .get() (err, res, body) ->
        msg.send body
