# Make hubot fetch quotes pertaining to the world's best secret agent, Archer.
# Hubot.
# HUBOT.
# HUBOT!!!!
# WHAT?
# DANGER ZONE.
#
# get archer

# REQUIRED MODULES
# sudo npm install htmlparser
# sudo npm install soupselect
# sudo npm install jsdom
# sudo npm install underscore

Select     = require("soupselect").select
HtmlParser = require "htmlparser"
JsDom      = require "jsdom"
_          = require("underscore")

module.exports = (robot) ->

  robot.hear /^benoit/i, (msg) ->
    msg.send "balls"

  robot.hear /^loggin/i, (msg) ->
    msg.reply "call Kenny Loggins, 'cuz you're in the DANGER ZONE."

  robot.hear /^sitting down/i, (msg) ->
    msg.reply "What?! At the table? Look, he thinks he's people!"

  robot.hear "I love that you know how to do that.", (msg) ->
    msg.reply "And I love that I have an erection... that doesn't involve homeless people."

  robot.hear /archer/i, (msg) ->
    msg
      .http("http://en.wikiquote.org/wiki/Archer_(TV_series)")
      .header("User-Agent: Archerbot for Hubot (+https://github.com/github/hubot-scripts)")
      .get() (err, res, body) ->
        quotes = parse_html(body, "dl")
        quote = get_quote msg, quotes

get_quote = (msg, quotes) ->

  nodeChildren = _.flatten childern_of_type(quotes[Math.floor(Math.random() * quotes.length)])
  quote = (textNode.data for textNode in nodeChildren).join(' ').replace(/^\s+|\s+$/g, '')

  msg.send quote

# Helpers
parse_html = (html, selector) ->
  handler = new HtmlParser.DefaultHandler((() ->), ignoreWhitespace: true)
  parser  = new HtmlParser.Parser handler

  parser.parseComplete html
  Select handler.dom, selector

childern_of_type = (root) ->
  return [root] if root?.type is "text"

  if root?.children?.length > 0
    return (childern_of_type(child) for child in root.children)

get_dom = (xml) ->
  body = JsDom.jsdom(xml)
  throw Error("No XML data returned.") if body.getElementsByTagName("FilterReturn")[0].childNodes.length == 0
  return body
