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
#   hubot <anything related to size, speed, quality, specific body parts> - Hubot will "that's what she said" that ish
#
# Author:
#   dhchow

var twss = require('twss');
module.exports = (robot) ->
  robot.hear //, (msg) ->
  if (twss.is(robot.msg)) {
    msg.send "... that's what she said."
