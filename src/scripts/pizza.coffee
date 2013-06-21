# Description:
#   Displays a random pizza gif from animatedpizzagifs.com
#
# Dependencies:
#   "jsdom": "~0.2.13"
#
# Configuration:
#   HUBOT_MORE_PIZZA - Show pizza GIFs even when it's not directed at hubot
#
# Commands:
#   hubot pizza - Show a pizza gif
#
# Author:
#   iangreenleaf

jsdom = require "jsdom"
PIZZA = "http://animatedpizzagifs.com"

module.exports = (robot) ->
  func = if env.HUBOT_MORE_PIZZA then 'hear' else 'respond'
  robot[func] /pizza/i, (msg) ->
    msg.http(PIZZA)
      .path("/")
      .get() (err, res, body) ->
        document = jsdom.jsdom body, null, features: { "QuerySelector": true, 'ProcessExternalResources': false }
        img = msg.random document.querySelectorAll "li img"
        msg.send "#{PIZZA}/#{img.src}"
