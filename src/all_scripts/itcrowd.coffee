# Description:
#   Make hubot fetch quotes pertaining The IT Crowd
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#   "jsdom": "0.2.14"
#   "underscore": "1.3.3"
#
# Configuration:
#   None
#
# Commands:
# 
# Author:
#   rrix

Select     = require("soupselect").select
HtmlParser = require "htmlparser"
JsDom      = require "jsdom"
_          = require("underscore")

module.exports = (robot) ->

  robot.respond /itcrowd quote$/i, (msg) ->
    msg
      .http("http://en.wikiquote.org/wiki/The_IT_Crowd")
      .header("User-Agent: Crowdbot for Hubot (+https://github.com/github/hubot-scripts)")
      .get() (err, res, body) ->
        quotes = parse_html(body, "dl")
        quote = get_quote msg, quotes

get_quote = (msg, quotes) ->

  nodeChildren = _.flatten children_of_type(quotes[Math.floor(Math.random() * quotes.length)])
  quote = (textNode.data for textNode in nodeChildren).join(' ').replace(/^\s+|\s+$/g, '')

  msg.send quote

# Helpers
parse_html = (html, selector) ->
  handler = new HtmlParser.DefaultHandler((() ->), ignoreWhitespace: true)
  parser  = new HtmlParser.Parser handler

  parser.parseComplete html
  Select handler.dom, selector

children_of_type = (root) ->
  return [root] if root?.type is "text"

  if root?.children?.length > 0
    return (children_of_type(child) for child in root.children)

get_dom = (xml) ->
  body = JsDom.jsdom(xml)
  throw Error("No XML data returned.") if body.getElementsByTagName("FilterReturn")[0].childNodes.length == 0
  return body
