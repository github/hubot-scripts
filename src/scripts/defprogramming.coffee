# def programming - Display a random programming quote from defprogramming.com

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
