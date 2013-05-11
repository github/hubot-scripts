# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   fml - A random message from fmylife.com
#
# Author:
#   artfuldodger

module.exports = (robot) ->
  robot.respond /fml/i, (msg) ->
    fml msg

fml = (msg) ->
  msg
    .http('http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&q=http://feeds.feedburner.com/fmylife')
      .get() (err, res, body) ->
        fmls = JSON.parse(body)
        random = Math.round(Math.random() * fmls.responseData.feed.entries.length)
        text = fmls.responseData.feed.entries[random].content
        text = text[0..text.indexOf('<img')-1]
        msg.send text
