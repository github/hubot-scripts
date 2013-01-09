# Description:
#   Allows Hubot to lambast someone with a random insult
#
# Dependencies:
#   "cheerio: "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot insult <name> - give <name> the what-for
#
# Author:
#   ajacksified, brandonvalentine

cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /insult (.*)/i, (msg) ->
    name = msg.match[1].trim()
    insult(msg, name)

insult = (msg, name) ->
  msg
    .http("http://www.randominsults.net")
    .header("User-Agent: Insultbot for Hubot (+https://github.com/github/hubot-scripts)")
    .get() (err, res, body) ->
      msg.send "#{name}: #{getQuote body}"

getQuote = (body) ->
  $ = cheerio.load(body)
  $('i').text()
