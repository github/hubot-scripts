# Description:
#   JWZ Blog Feed
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot jwz last <N> - get the last N posts
#
# Notes:
#   We make an assumption that the video is youtube, not always true, plz2bfixing
#   Stolen from the hackernews.coffee script
#
# Author:
#   MonkeyIsNull

NodePie = require("nodepie")
Cheerio = require("cheerio")

jwzFeedUrl = "http://www.jwz.org/blog/feed/"


module.exports = (robot) ->
  robot.respond /JWZ last (\d+)?/i, (msg) ->
    msg.http(jwzFeedUrl).get() (err, res, body) ->
      if res.statsCode is not 200
        msg.send "Oh my, something has gone dreadfully wrong"
      else
        feed = new NodePie(body)
        try
          feed.init()
          count = msg.match[1] || 5
          items = feed.getItems(0, count)
          for item in items
            $ = Cheerio.load(item.getContents())
            msg.send false_cleaner(item.getTitle()) + desc_cleaner(item.getDescription()) + get_first($)
        catch e
          console.log(e)
          msg.send "Jinkies, apparently there has been a problem!"

# All these are utils for cleaning up the garbled results
false_cleaner = (data) ->
  if data is false
    " "
  else
    data

desc_cleaner = (data) ->
  if data is false
    " "
  else
    "  ( #{data})  "

undef_cleaner = (data) ->
  if data is undefined
    return " "
  data

not_a_previously_link = ($) ->
  if $('a').first().html() == "Previously"
    return undefined
  else
    return $('a').first().attr('href')

get_first = ($) ->
  link = not_a_previously_link($)
  vid  = $('iframe').first().attr('src')
  if vid == undefined
    undef_cleaner(link)
  else # uhoh, we are making an assumption here that it's youtube, bad bad!
    vid2  = "http://www.youtube.com/watch?v=" + $('iframe').first().attr('src').match(/r?embed\/(.*)\?/)[1]
    undef_cleaner(link) + " " + vid2
