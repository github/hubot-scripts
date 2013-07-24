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
#   zen
#   !zen
#
# Author:
#   Anil Wadghule
#   @anildigital
#

# Respond with GitHub zen API message
module.exports = (robot) ->
  robot.hear /zen/i, (msg) ->
    msg
      .http("https://api.github.com/zen")
      .get() (err, res, body) ->
        msg.send body