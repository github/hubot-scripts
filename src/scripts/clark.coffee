# Description:
#   None
#
# Dependencies:
#   "clark": "0.0.5"
#
# Configuration:
#   None
#
# Commands:
#   hubot clark <data> - build sparklines out of data
#
# Author:
#   ajacksified

clark = require('clark').clark

module.exports = (robot) ->
  robot.respond /clark (.*)/i, (msg) ->
    data = msg.match[1].trim().split(' ')
    msg.send(clark(data))

