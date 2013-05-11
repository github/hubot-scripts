# Description:
#   Displays a random pizza gif from animatedpizzagifs.com
#
# Dependencies:
#   "jsdom": "~0.2.13"
#
# Configuration:
#   None
#
# Commands:
#   hubot pizza - Show a pizza gif
#
# Author:
#   iangreenleaf

jsdom = require "jsdom"
PIZZA = "http://animatedpizzagifs.com"

module.exports = (robot) ->
  robot.respond /pizza/i, (msg) ->
    msg.http(PIZZA)
      .path("/")
      .get() (err, res, body) ->
        document = jsdom.jsdom body, null, features: { "QuerySelector": true, 'ProcessExternalResources': false }
        img = msg.random document.querySelectorAll "li img"
        msg.send "#{PIZZA}/#{img.src}"
