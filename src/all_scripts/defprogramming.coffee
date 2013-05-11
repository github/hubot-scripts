# Description:
#   None
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot def programming - Display a random programming quote from defprogramming.com
#
# Author:
#   daviferreira

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
    robot.respond /def programming/i, (msg) ->
        msg.http("http://www.defprogramming.com/random")
           .get() (err, res, body) ->
               handler = new HtmlParser.DefaultHandler()
               parser  = new HtmlParser.Parser handler

               parser.parseComplete body

               results = Select handler.dom, "cite a p"
               msg.send results[0].children[0].raw
