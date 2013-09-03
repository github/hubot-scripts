# Description:
#   Fetches an image of the Mint Plaza Blue Bottle Line.
#
# Dependencies:
#   "cheerio": "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot blue bottle me - gets an image of the line at the Mint Plaza Blue Bottle Coffee
#
# Author:
#   sloanesturz

cheerio = require('cheerio')

module.exports = (robot) ->

  robot.respond /blue bottle me/i, (msg) ->
    msg.http('http://bb.zaarly.com/').get() (err, res, body) ->
      if res.statusCode != 200
        msg.send "Couldn't access http://bb.zaarly.com. No coffee for you!"
      else
        $ = cheerio.load(body)
        url = $('body').attr('style').match(/url\('(.+)'\)/)[1]
        msg.send url
