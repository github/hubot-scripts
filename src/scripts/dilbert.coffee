# Description:
#   Dilbert
#
# Dependencies:
#   "htmlparser": "1.7.6"
#
# Configuration:
#   None
#
# Commands:
#   hubot show me dilbert - gets the daily dilbert
#
# Author:
#   evilmarty

htmlparser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /((show|fetch)( me )?)?dilbert/i, (msg) ->
    dilbertRss msg, (url) ->
      msg.send url

dilbertRegexp = /src=&quot;(.*.gif)/i
dilbertRss = (msg, cb) ->
  msg.http('http://pipes.yahoo.com/pipes/pipe.run?_id=1fdc1d7a66bb004a2d9ebfedfb3808e2&_render=rss')
    .get() (err, resp, body) ->
      handler = new htmlparser.RssHandler (error, dom) ->
        return if error || !dom
        item = dom.items[0]
        match = item.description.match(dilbertRegexp)
        cb match[1] if match

      parser = new htmlparser.Parser(handler)
      parser.parseComplete(body)