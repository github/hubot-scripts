# Random meme from 9gag
# Rewrite by Enrique Vidal

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot)->
  robot.respond /9gag/i, (message)->
    send_meme message, (text)->
      message.send text

send_meme = (message, response_handler)->
  meme_domain = "http://9gag.com"
  message.http( meme_domain + "/random" ).get() (error, response, body)->
    return response_handler "Sorry, something went wrong" if error

    response get_meme_image( body, ".img-wrap a img" ).children[0]['src']

get_meme_image = (body)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser handler

  html_parser.parseComplete body
  Select handler.dom, selector
