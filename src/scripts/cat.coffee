# Description:
#   Send messages to channels via hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CAT_PORT
#
# Commands:
#   None
#
# Notes:
#   $ echo "#channel|hello everyone" | nc -u -w1 bot_hostname bot_port
#   $ echo "nickname|hello mister" | nc -u -w1 bot_hostname bot_port
#
# Author:
#   simon

dgram = require "dgram"
server = dgram.createSocket "udp4"

module.exports = (robot) ->
  server.on 'message', (message, rinfo) ->
    msg = message.toString().trim().split("|")
    target = msg[0]
    console.log("Sending '#{msg[1]}' to '#{target}'");
    user = { room: target }
    robot.send user, msg[1]
  server.bind(parseInt(process.env.HUBOT_CAT_PORT))
