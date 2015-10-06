# Description:
#   Base64 encoding and decoding
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot base64 encode|decode <query> - Base64 encode or decode <string>
#
# Author:
#   jimeh

module.exports = (robot) ->
  robot.respond /base64 encode( me)? (.*)/i,{id: 'base64.encode'}, (msg) ->
    msg.send new Buffer(msg.match[2]).toString('base64')

  robot.respond /base64 decode( me)? (.*)/i,{id: 'base65.decode'}, (msg) ->
    msg.send new Buffer(msg.match[2], 'base64').toString('utf8')
