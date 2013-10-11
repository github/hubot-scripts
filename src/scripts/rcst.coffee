# Description:
#   Riot Clit Shave Tmblr Picture Feed - Sometimes NSFW
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot rcst last <N> - get the last N posts from rcs' tumblr feed
#
# Notes:
#   Stolen from the hackernews.coffee script
#
# Author:
#   MonkeyIsNull

NodePie = require("nodepie")
Cheerio = require("cheerio")

rcstFeedUrl = "http://riotclitshave.tumblr.com/rss"

module.exports = (robot) ->
  robot.respond /RCST last (\d+)?/i, (msg) ->
    msg.http(rcstFeedUrl).get() (err, res, body) ->
      if res.statsCode is not 200
        msg.send "Oh dear, something went wrong"
      else
        feed = new NodePie(body)
        try
          feed.init()
          count = msg.match[1] || 5
          items = feed.getItems(0, count)
          for item in items
            $ = Cheerio.load(item.getDescription())
            $('img').each ( ) ->
              msg.send $(this).attr('src')
        catch e
          console.log(e)
          msg.send "Something has gone horribly wrong, yo!"
