# Description:
#   Returns a random image from pinterest
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot pin|pinterest me <query> - Returns a random image from pinterest for <query>
#
# Author:
#   rasyidmujahid 

select      = require("soupselect").select
htmlparser  = require("htmlparser")

html_handler  = new htmlparser.DefaultHandler((()->), ignoreWhitespace: true )
html_parser   = new htmlparser.Parser html_handler

module.exports = (robot) ->
  robot.respond /(pin|pinterest)( me)? (.*)/i, (msg) ->
    pin_me msg, 'http://pinterest.com/search/pins/?', msg.match[3], (url) ->
      msg.send url

pin_me = (msg, url, query, cb) ->
  http msg, url, query, (err, res, body) ->
    pin_url = get_pin_url(body, 'a.PinImage.ImgLink')
    if pin_url?
      http msg, pin_url, null, (err, res, body) ->
        cb get_pin_img(body, 'img#pinCloseupImage')
    else cb 'Sorry no pin found.'

http = (msg, url, query, cb) ->
  msg.http(url)
    .query(q: query)
    .get() cb
  
get_pin_url = (body, selector) ->
  html_parser.parseComplete body
  pins = select(html_handler.dom, selector)
  if pins.length <= 0
    return null
  idx = Math.floor(Math.random() * pins.length)
  'http://pinterest.com' + pins[idx].attribs.href

get_pin_img = (body, selector) ->
  html_parser.parseComplete body
  select(html_handler.dom, selector)[0].attribs.src