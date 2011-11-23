# Capture a webpage as an image using the bluga.net Easythumb API. API user and key needed from http://webthumb.bluga.net/api
#
# webshot me <url> - Captures the given url as an image.

hashlib=require('hashlib')

module.exports = (robot) ->
  robot.respond /webshot( me)? (.*)/i, (msg) ->
    if process.env.HUBOT_WEBTHUMB_USER and process.env.HUBOT_WEBTHUMB_API_KEY
      url = msg.match[2]
      console.log(url)
      msg.send 'http://webthumb.bluga.net/easythumb.php?user=' + process.env.HUBOT_WEBTHUMB_USER + '&url=' + encodeURIComponent(url) + '&size=large&hash=' + webthumbhash(process.env.HUBOT_WEBTHUMB_API_KEY, url) + '&cache=14#.jpeg'

webthumbhash = (apikey, url) =>
  now = new Date
  now = new Date(now.getTime() - (now.getTimezoneOffset() * 1000))
  month = (now.getUTCMonth() < 9 ? '0' : '') + (now.getUTCMonth()+1)
  day = (now.getUTCDate() < 10 ? '0' : '') + now.getUTCDate()
  hashlib.md5(now.getUTCFullYear().toString() + month + day + url + apikey)
