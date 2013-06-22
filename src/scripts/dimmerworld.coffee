# Description:
#  "Your very own Dimmerworld simulator."
#
# Dependencies:
#  "cleverbot-node": "0.1.1"
#
# Configuration:
#   None
#
# Commands:
#   dimmer <input>
#
# Author:
#   zachlatta

dimmer = require('cleverbot-node')

module.exports = (robot) ->
  d = new dimmer()

  robot.respond /^dimmer/i, (msg) ->
    data = msg.match[1].trim()
    d.write(data, (d) => msg.send(d.message))
