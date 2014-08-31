# Description
#   Hubot inspires you with a quote
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot inspire
#    
# Notes:
#   None
#
# Author:
#   Minh-Tue Vo

module.exports = (robot) ->

  robot.respond /inspire/i, (msg) ->
    msg.http("http://www.all-famous-quotes.com/quotes_generator.html")
      .get() (err, res, body) ->
        quote = body.match(/\<blockquote class="new"\>(.*)\<a href/)[1]
        author = body.match(/target="_blank" class="link"  title="(.*)">(.*)\<\/a\>/)[2]
        msg.send quote + author