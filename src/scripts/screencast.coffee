# Description:
#   Post screencast image link
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   http://screencast.com/... - Display image from Screencast
#
# Author:
#   Chris Larson

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot) ->
  robot.hear /(http:\/\/)?screencast.com\/t\/([^\s]*)/i, (msg) ->
    SCShortId = escape(msg.match[2])
    try
      msg.http("http://screencast.com/t/"+SCShortId).get() (err, resp, body) ->
        htmlHandler  = new HTMLParser.DefaultHandler( (()->), ignoreWhitespace: true )
        htmlParser   = new HTMLParser.Parser htmlHandler

        htmlParser.parseComplete body
        try
          url = Select( htmlHandler.dom, "img.embeddedObject" )[0].attribs.src
        catch error
        msg.send url
    catch error