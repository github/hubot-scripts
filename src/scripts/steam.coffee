# Description
#   The plugin will provide a picture and a link of the daily deal from Steam
#
# Dependencies:
#   "htmlparser": "1.8.0"
#   "soupselect": "0.2.0"
#   "validator" : "0.4.20"
# 
# Configuration:
#   None
#
# Commands:
#   hubot daily deal - <It will show you Steam's daily deal>
#
# Notes:
#   soupselect depends on htmlparser so install both using "npm install soupselect" and "npm install htmlparser". Don't forget: "npm install validator" 
#   You might need to be root user to install the dependencies
#
# Author:
#   smiklos

Select = require("soupselect").select
HTMLParser = require "htmlparser"
sanitize = require('validator').sanitize

module.exports = (robot) ->
  robot.respond /daily deal/i, (msg) ->
    getDeals msg, (deal) ->
      msg.send deal[0], deal[1]

getDeals = (msg, callback) ->
    location = "http://store.steampowered.com"
    msg.http(location).get() (error,response, body) ->
      return msg.send "Something went wrong..." if error
      deal = parseDeals body, ".dailydeal a"
      callback deal

parseDeals = (body, selector) ->
  handler = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true)
  parser = new HTMLParser.Parser handler
  parser.parseComplete body 
  dealObj = Select(handler.dom, selector)[0]
  if dealObj?
    originalPrice = Select(handler.dom, '.dailydeal_content .discount_original_price')[0]
    finalPrice = Select(handler.dom, '.dailydeal_content .discount_final_price')[0]
    image = "#{dealObj.children[0].attribs.src.replace /[?].*/ , ''}"
    deal = "From #{sanitize(originalPrice.children[0].data).entityDecode().trim()} to #{sanitize(finalPrice.children[0].data).entityDecode().trim()} #{dealObj.attribs.href}"
    response = [image, deal]
  else 
    msg.send "No daily deal found"



