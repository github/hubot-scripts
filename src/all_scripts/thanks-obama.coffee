# Description
#   Blames Obama for everything that's bad in your life.
#
# Dependencies:
#   "cheerio": "0.10.7",
#   "request": "2.14.0"
#
# Configuration:
#   None
#
# Commands:
#   thanks obama - A random image from http://thanks-obama.tumblr.com
#
# Notes:
#   It would be nice if we could load a larger sample of images.
#
# Author:
#   raykrueger
#
request = require 'request'
cheerio = require 'cheerio'
url = "http://thanks-obama.tumblr.com/"

module.exports = (robot) ->

  robot.hear /thanks obama/i, (msg) ->
    request "#{url}?page=#{Math.floor(Math.random() * 8)}", (error, response, body)->
      throw error if error
      $ = cheerio.load(body)
      images = $("div.cont.group img").toArray()
      image = images[Math.floor(Math.random()*images.length)]
      msg.send $(image).attr("src") if image

