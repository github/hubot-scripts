# Description:
#   None
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot 9gag me - Returns a random meme image
#
# Author:
#   EnriqueVidal

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot)->
  robot.respond /9gag( me)?/i, (message)->
    send_meme message, false, (url, title)->
      message.send url, title

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

    img_src = get_meme_image( body, ".badge-item-animated-img" )
    img_title = escape_html_characters( get_meme_title( body, ".badge-item-title" ))

    if img_src.substr(0, 4) != "http"
      img_src = "http:#{img_src}"

    response_handler img_src, img_title

select_element = (body, selector)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, selector )[0]

get_meme_image = (body, selector)->
  select_element(body, selector).attribs.src

get_meme_title = (body, selector)->
  select_element(body, selector).children[0].raw

escape_html_characters = (text)->
  replacements = [
    [/&/g, '&amp;']
    [/</g, '&lt;']
    [/"/g, '&quot;']
    [/'/g, '&#039;']
  ]

  for r in replacements
    text.replace r[0], r[1]
