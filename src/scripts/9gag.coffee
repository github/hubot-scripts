# Description:
#   None
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   HUBOT_9GAG_NO_GIFS (optional; default is "false")
#
# Commands:
#   hubot 9gag me - Returns a random meme image
#
# Author:
#   EnriqueVidal 
#
# Contributors:
#   dedeibel (gif support)

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot)->
  robot.respond /9gag( me)?/i, (message)->
    send_meme message, false, (text)->
      message.send text

send_meme = (message, location, response_handler)->
  meme_domain = "http://9gag.com"
  location  ||= "/random"
  if location.substr(0, 4) != "http"
    url = meme_domain + location
  else
    url = location

  message.http( url ).get() (error, response, body)->
    return response_handler "Sorry, something went wrong" if error

    if response.statusCode == 302
      location = response.headers['location']
      return send_meme( message, location, response_handler )

    no_gifs = process.env.HUBOT_9GAG_NO_GIFS
    selectors = ["a img.badge-item-img"]
    if no_gifs != '0' && no_gifs != 't' && no_gifs != 'true'
      selectors.unshift("div.badge-animated-container-animated img")

    img_src = get_meme_image( body, selectors )

    if img_src.substr(0, 4) != "http"
      img_src = "http:#{img_src}"

    response_handler img_src

get_meme_image = (body, selectors)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  for selector in selectors
    img_container = Select( html_handler.dom, selector )
    if img_container && img_container[0]
      return img_container[0].attribs.src
