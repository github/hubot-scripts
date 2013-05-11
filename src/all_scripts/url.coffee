# Description:
#   URL encoding and decoding
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot url encode|decode <query> - URL encode or decode <string>
#   hubot url form encode|decode <query> - URL form-data encode or decode <string>
#
# Author:
#   jimeh

module.exports = (robot) ->
  robot.respond /URL encode( me)? (.*)/i, (msg) ->
    msg.send encodeURIComponent(msg.match[2])

  robot.respond /URL decode( me)? (.*)/i, (msg) ->
    msg.send decodeURIComponent(msg.match[2])

  robot.respond /URL form encode( me)? (.*)/i, (msg) ->
    msg.send urlFormEncode(msg.match[2])

  robot.respond /URL form decode( me)? (.*)/i, (msg) ->
    msg.send urlFormDecode(msg.match[2])

# url form-data encoding helpers (partially ripped from jshashes npm package)
urlFormEncode = (str) ->
  escape(str)
    .replace(new RegExp('\\+','g'),'%2B')
    .replace(new RegExp('%20','g'),'+')

urlFormDecode = (str) ->
  unescape(str.replace(new RegExp('\\+','g'), ' '))
