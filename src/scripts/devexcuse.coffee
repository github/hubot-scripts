# Description:
#   Dev excuses scraper. From http://developerexcuses.com/
#
# Dependencies:
#
#   "cheerio": "~0.12.0"
#
# Commands:
#   hubot excuse me

cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /excuse me/i, (msg) ->
    robot.http("http://developerexcuses.com/")
      .get() (err, res, body) ->
        $ = cheerio.load(body)

        msg.send $('.wrapper a').text()