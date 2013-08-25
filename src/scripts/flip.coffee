# Description:
#   When things aren't going well, you must flip it. (╯°□°）╯︵ ʇoqnɥ
#
# Dependencies:
#   "flip": "~0.1.0"
#
# Commands:
#   hubot flip <text> - express your anger
#
# Author:
#   jergason

flip = require 'flip'

module.exports = (robot) ->
  robot.respond /(flip) (.*)$/i, (msg) ->
    toFlip = msg.match[2]
    flipped = flip(toFlip)
    msg.send "(╯°□°）╯︵ #{flipped}"
