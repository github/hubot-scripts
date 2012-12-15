# Description:
#   Hubot will respond to (in)appropriate lines with "That's what she said"
#
# Dependencies:
#   twss
#
# Configuration:
#   None
#
# Commands:
#   Will listen for good opportunities to drop a twss joke.
#
# Author:
#   thallium205

twss = require('twss')
twss.threshold = .9
module.exports = (robot) ->
  robot.hear /\S/, (msg) ->
    if twss.is(msg.message.text)
      msg.send "... that's what she said."