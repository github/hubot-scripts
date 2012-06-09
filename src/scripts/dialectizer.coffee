# Description:
#   Allows Hubot to translate text into various dialects
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot dialectize|dialect|dia <dialect>|help <text> - Translates the given text into the given dialect
#
# Author:
#   facto

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

#TODO: get this dynamically?
dialects = ["redneck", "jive", "cockney", "fudd", "bork", "moron", "piglatin", "hckr", "censor"]

module.exports = (robot) ->
  robot.respond /(?:dialectize|dialect|dia) (\w+)(.*)/i, (msg) ->
    [dialect, text] = msg.match[1..2]
    if dialect in ["help", "h"]
      showHelp(msg)
      return
    
    return unless text
    trim text
    return unless text.length > 0
    
    if dialect in ["all", "a"]
      showDialectizedText(msg, dialect, text, true) for dialect in dialects
      return
    else if dialect is "hacker"
      dialect = "hckr"
    showDialectizedText(msg, dialect, text, false)

showDialectizedText = (msg, dialect, text, showPrefix) ->
    msg.http("http://www.rinkworks.com/dialect/dialectt.cgi?dialect=" + encodeURIComponent(dialect) + "&text=" + encodeURIComponent(text))
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler
        parser.parseComplete body
        result = Select handler.dom, ".dialectized_text p"
        return unless result
        dialectizedText = trim result[0].children[0].raw
        dialectizedText = "#{dialect}: " + dialectizedText if showPrefix
        msg.send dialectizedText

showHelp = (msg) ->
  msg.send "Dialects: " + dialects.join(", ")

trim = (string) ->
  return string.replace(/^\s*|\s*$/g, '')

