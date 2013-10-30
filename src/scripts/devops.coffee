# Description:
#   Because devops are devops.
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot devops me - Grab a random gif from http://devopsreactions.tumblr.com/
#
# Author:
#   epinault

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /devops me/i, (msg) ->
    randevopsMe msg, (url, title) ->
      msg.send title
      msg.send url

randevopsMe = (msg, cb) ->
  msg.http("http://devopsreactions.tumblr.com/random")
    .get() (err, res, body) ->
      console.log res.headers.location
      devopsMe msg, res.headers.location, (location, title) ->
        cb location , title

devopsMe = (msg, location, cb) ->
  msg.http(location)
    .get() (err, res, body) ->
      handler = new HtmlParser.DefaultHandler()
      parser  = new HtmlParser.Parser handler

      parser.parseComplete body
      img = Select handler.dom, "#content #left #blog_posts .item_content img"
      title = Select handler.dom, "#content #left #blog_posts .post_title a"
      console.log img
      console.log title[0].children

      cb img[0].attribs.src, title[0].children[0].data

