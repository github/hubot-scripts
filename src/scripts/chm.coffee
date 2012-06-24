# Description:
#   Shows a short history lesson of the day from the Computer History Museum
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot today in computer history|tdih|chm - Displays the content from the This Day in History page on the Computer History Museum site
#
# Author:
#   facto

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /(today in computer history|tdih|chm)$/i, (msg) ->
    msg.http("http://www.computerhistory.org/tdih/")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler
        parser.parseComplete body
        
        contentEl = Select handler.dom, ".tdihevent p"
        return unless contentEl
        msg.send date(handler)
        msg.send title(contentEl)
        for sentence in blurbSentences(contentEl)
          msg.send sentence + '.' if sentence and sentence isnt ""
          
title = (contentEl) ->
  trim contentEl[0].children[0].raw
  
blurbSentences = (contentEl) ->
  blurb = trim contentEl[1].children[0].raw
  blurb.split('.')
          
date = (handler) ->
  dateEl = Select handler.dom, ".title"
  return "" unless dateEl
  trim dateEl[0].children[0].raw
        
trim = (string) ->
  return string.replace(/^\s*|\s*$/g, '')
