# gifbin me - Return random gif from gifbin.com

# Random gif from gifbin.com
# Enrique Vidal - enrique@cloverinteractive.com

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"
gif_domain  = "http://www.gifbin.com"

module.exports = (robot)->
  robot.respond /gifbin( me)?/i, (message)->
    send_gif message, false, (text)->
      message.send text

send_gif = (message, location, response_handler)->
  location ||= gif_domain + "/random"
  message.http( location ).get() (error, response, body)->
    return response_handler "Sorry, something went wrong" if error

    if response.statusCode == 301
      location = response.headers['location']
      return send_gif( message, location, response_handler )

    response_handler get_gif( body, ".box a img" )

get_gif = (body, selector)->
  html_handler  = new HTMLParser.DefaultHandler( (()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, selector )[0].attribs.src
