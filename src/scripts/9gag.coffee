# Random meme from 9gag
# Rewrite by Enrique Vidal

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot)->
  robot.respond /9gag/i, (message)->
    send_meme message, false, (text)->
      message.send text

send_meme = (message, location, response_handler)->
  meme_domain = "http://9gag.com"
  location  ||= "/random"
  url         = meme_domain + location

  message.http( url ).get() (error, response, body)->
    return response_handler "Sorry, something went wrong" if error

    if response.statusCode == 302
      location = response.headers['location']
      return send_meme( message, location, response_handler )

    response_handler get_meme_image( body, ".img-wrap img" )

get_meme_image = (body, selector)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, selector )[0].attribs.src
