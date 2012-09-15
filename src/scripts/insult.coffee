# Description:
#   Allows Hubot to lambast someone with a random insult
#
# Dependencies:
#   "soupselect: "0.2.0"
#   "htmlparser": "1.7.6"
#
# Configuration:
#   None
#
# Commands:
#   hubot insult <name> - give <name> the what-for
#
# Authors:
#   ajacksified, brandonvalentine

Select     	= require("soupselect").select
HtmlParser  = require "htmlparser"

module.exports = (robot) ->
  robot.respond /insult (.*)/i, (msg) ->
    name = msg.match[1].trim()
    insult(msg, name)

insult = (msg, name) ->
  msg
    .http("http://www.randominsults.net")
    .header("User-Agent: Insultbot for Hubot (+https://github.com/github/hubot-scripts)")
    .get() (err, res, body) ->
      quote = parse_html body, "i"
      msg.send name + ": " + parse_quote(quote)

parse_html = (html, selector) ->
  handler = new HtmlParser.DefaultHandler((() ->), ignoreWhitespace: true)
  parser  = new HtmlParser.Parser handler

  parser.parseComplete html
  Select handler.dom, selector

parse_quote = (quote) ->
  quote[0].children[0].data
