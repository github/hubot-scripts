# Description:
#   Display meme from "les joies du code <http://lesjoiesducode.tumblr.com>".
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot joie - Returns a random meme (text and image)
#   hubot dernière joie - Returns last meme (text and image). 'hubot derniere joie' also available.
#
# Author:
#   Eunomie
#   Based 9gag.coffee by EnriqueVidal 

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot)->
  robot.respond /joie/i, (message)->
    send_meme message, '/random', (text)->
      message.send text
  robot.respond /derni[èe]re joie/i, (message)->
    send_meme message, '', (text)->
      message.send text

send_meme = (message, location, response_handler)->
  meme_domain = "http://lesjoiesducode.tumblr.com"
  if location.substr(0, 4) != "http"
    url = meme_domain + location
  else
    url = location

  message.http( url ).get() (error, response, body)->
    return response_handler "Sorry, something went wrong" if error

    if response.statusCode == 302
      location = response.headers['location']
      return send_meme( message, location, response_handler )

    img_src = get_meme_image( body, ".post .c1 img" )

    if img_src.substr(0, 4) != "http"
      img_src = "http:#{img_src}"

    txt = get_meme_txt( body, ".post h3 a" )

    response_handler "#{txt} #{img_src}"

get_meme_image = (body, selector)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, selector )[0].attribs.src

get_meme_txt = (body, selector)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, selector )[0].children[0].raw