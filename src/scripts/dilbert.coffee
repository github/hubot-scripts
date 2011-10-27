// Kudos to Scott Adams for an awesome comic.

$ = require "jquery"

module.exports = (robot) ->
  robot.respond /(show( me)?|fetch ( me)? )?dilbert/i, (msg) ->
    dilbertRss msg, (url) ->
      msg.send url

dilbertRss = (msg, cb) ->
  msg.http('http://feed.dilbert.com/dilbert/daily_strip?format=xml')
    .get() (err, resp, body) ->
      content = $(body).find('item > description').eq(0).text()
      if url = $('<div>' + content + '</div>').find('img[src*="dilbert.com"]').attr('src')
        cb url