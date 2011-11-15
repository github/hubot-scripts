# Shows a short history lesson of the day from the Computer History Museum.
#
# today in computer history|tdih|chm - Displays the content from the This Day in History page on the Computer History Museum site.
#
Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /(today in computer history|tdih|chm)$/i, (msg) ->
    msg.http("http://www.computerhistory.org/tdih/")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler
        parser.parseComplete body
        result = Select handler.dom, ".tdihevent p"
        return unless result
        title = trim result[0].children[0].raw
        blurb = trim result[1].children[0].raw
        sentences = blurb.split('.')
        msg.send title
        for sentence in sentences
          msg.send sentence + '.' if sentence and sentence isnt ""
        
trim = (string) ->
  return string.replace(/^\s*|\s*$/g, '')
