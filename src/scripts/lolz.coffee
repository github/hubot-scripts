# Description:
#   None
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
# 
# Configuration:
#   None
#
# Commands:
#   hubot lulz - BRING THE LOLZ from bukk.it
#
# Author:
#   dstrelau

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /l[ou]lz$/i, (msg) ->
    msg.http("http://bukk.it")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler

        parser.parseComplete body

        results = ("http://bukk.it/#{link.attribs.href}" for link in Select handler.dom, "td a")
        msg.send msg.random results
  robot.respond /l[ou]lz\s*bomb (\d+)?/i, (msg) ->
    count = msg.match[1] || 5
    count = 5 if count > 20

    msg.http("http://bukk.it")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler

        parser.parseComplete body

        results = ("http://bukk.it/#{link.attribs.href}" for link in Select handler.dom, "td a")
        for num in [count..1]
          msg.send msg.random results
