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

module.exports = (robot) ->
  robot.respond /(pin|pinterest)( me)? (.*)/i, (msg) ->
    pin_me msg, msg.match[3], (url) ->
      msg.send url

pin_me = (msg, query, cb) ->
  msg.http('http://pinterest.com/search/pins/?')
    .query(q: query)
    .get() (err, res, body) ->
      cb get_img_src(body, "img.PinImageImg")

get_img_src = (body, selector)->
  html_handler  = new htmlparser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new htmlparser.Parser html_handler

  html_parser.parseComplete body
  imgs = select(html_handler.dom, selector)
  if imgs.length <= 0
    return "No pin found"
  idx = Math.floor(Math.random() * imgs.length)
  imgs[idx].attribs.src
