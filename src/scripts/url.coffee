# URL encoding and decoding.
#
# url encode|decode <query> - URL encode or decode <string>

module.exports = (robot) ->
  robot.respond /URL encode( me)? (.*)/i, (msg) ->
    msg.send urlEncode(msg.match[2])

  robot.respond /URL decode( me)? (.*)/i, (msg) ->
    msg.send urlDecode(msg.match[2])

# url encoding helpers (shamelessly ripped from `jshashes` npm package)
urlEncode = (str) ->
  escape(str)
    .replace(new RegExp('\\+','g'),'%2B')
    .replace(new RegExp('%20','g'),'+')

urlDecode = (str) ->
  unescape(str.replace(new RegExp('\\+','g'), ' '))
