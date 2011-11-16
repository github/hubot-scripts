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
        dateEl = Select handler.dom, ".title"
        contentEl = Select handler.dom, ".tdihevent p"
        return unless dateEl and contentEl
        title = trim contentEl[0].children[0].raw
        blurb = trim contentEl[1].children[0].raw
        sentences = blurb.split('.')
        date = trim dateEl[0].children[0].raw
        msg.send date
        msg.send title
        for sentence in sentences
          msg.send sentence + '.' if sentence and sentence isnt ""
        
trim = (string) ->
  return string.replace(/^\s*|\s*$/g, '')
