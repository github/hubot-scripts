# lulz - BRING THE LOLZ from bukk.it

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /.*l[ou]lz/i, (msg) ->
    msg.http("http://bukk.it")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler

        parser.parseComplete body

        results = ("http://bukk.it/#{link.attribs.href}" for link in Select handler.dom, "td a")
        msg.send msg.random results
