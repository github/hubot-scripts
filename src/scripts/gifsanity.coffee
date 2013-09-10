# Description:
#   Pulls GIFs from various insane tumblrs
#
# Dependencies:
#   "tumblrbot": "0.1.0"
#
# Configuration:
#   HUBOT_TUMBLR_API_KEY - A Tumblr OAuth Consumer Key will work fine
#
# Commands:
#   hubot gif me - Returns a random gif from a random blog
#   hubot food mosh - Returns a random gif from foodmosh.tumblr.com
#   hubot fluxmachine - Returns a random gif from fluxmachine.tumblr.com
#   hubot android - Returns a random gif from milosrajkovic.tumblr.com
#   hubot nic cage me - Returns a random gif from gifolas-cage.tumblr.com
#
# Author:
#   iangreenleaf

tumblr = require "tumblrbot"
SOURCES = {
  "foodmosh.tumblr.com": /(food)( mosh)?( me)?/i
  "fluxmachine.tumblr.com": /(flux)( ?machine)?( me)?/i
  "gifolas-cage.tumblr.com": /(nic )?cage( me)?/i
  "milosrajkovic.tumblr.com": /(android )( me)?/i
}

getGif = (blog, msg) ->
  tumblr.photos(blog).random (post) ->
    msg.send post.photos[0].original_size.url

module.exports = (robot) ->
  robot.respond /gif(sanity)?( me)?/i, (msg) ->
    blog = msg.random Object.keys(SOURCES)
    getGif blog, msg

  for blog,pattern of SOURCES
    robot.respond pattern, (msg) ->
      getGif blog, msg
