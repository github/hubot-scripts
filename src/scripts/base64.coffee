# Base64 encoding and decoding.
#
# base64 encode|decode <query> - Base64 encode or decode <string>

module.exports = (robot) ->
  robot.respond /base64 encode( me)? (.*)/i, (msg) ->
    msg.send new Buffer(msg.match[2]).toString('base64')

  robot.respond /base64 decode( me)? (.*)/i, (msg) ->
    msg.send new Buffer(msg.match[2], 'base64').toString('utf8')
