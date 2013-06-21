# Description:
#   Displays a random pizza gif from animatedpizzagifs.com
#
# Dependencies:
#   "tumblrbot": "0.1.0"
#
# Configuration:
#   HUBOT_TUMBLR_API_TOKEN
#   HUBOT_MORE_PIZZA
#
# Commands:
#   hubot pizza - Show a pizza gif
#
# Author:
#   iangreenleaf

tumblr = require 'tumblrbot'
PIZZA = "pizzagifs.tumblr.com"

module.exports = (robot) ->
  func = if process.env.HUBOT_MORE_PIZZA then 'hear' else 'respond'
  robot[func](/pizza/i, (msg) ->
    tumblr.photos(PIZZA).random (post) ->
      msg.send post.photos[0].original_size.url
  )
