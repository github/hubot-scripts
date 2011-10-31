htmlparser = require "htmlparser"
sys = require "sys"

module.exports = (robot) ->
  robot.respond /(show( me)?|fetch ( me)? )?dilbert/i, (msg) ->
    dilbertRss msg, (url) ->
      msg.send url

dilbertRegexp = /img src="(http:\/\/dilbert.com\/[^"]+)"/i
dilbertRss = (msg, cb) ->
  msg.http('http://feed.dilbert.com/dilbert/daily_strip?format=xml')
    .get() (err, resp, body) ->
      handler = new htmlparser.RssHandler (error, dom) ->
        return if error || !dom
        item = dom.items[0]
        match = item.description.match(dilbertRegexp)
        cb match[1] if match
          
      parser = new htmlparser.Parser(handler)
      parser.parseComplete(body)