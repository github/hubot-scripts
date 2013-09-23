# Description:
#   gets photos of hash tag
#
# Dependencies:
#   "instagram-node-lib": "*"
#
# Configuration:
#   HUBOT_INSTAGRAM_CLIENT_KEY
#   HUBOT_INSTAGRAM_ACCESS_KEY
#
# Commands:
#   hubot insta tag <tag> <count>- Show recent instagram tags
#   by default count is 1 
#
# Author:
#   raysrashmi
#

config =
  client_key:  process.env.HUBOT_INSTAGRAM_CLIENT_KEY
  client_secret:  process.env.HUBOT_INSTAGRAM_ACCESS_KEY
 
Instagram = require('instagram-node-lib')
Instagram.set('client_id', config.client_key);
Instagram.set('client_secret', config.client_secret);
module.exports = (robot) ->
  robot.respond /(insta tag)( me )?(.*)/i, (msg) ->
    count = 1
    authenticate_user()
    if msg.match[3]
      text = msg.match[3].trim()
      text = text.split(" ")
      tag =  text[0]
      count = text[1] if text[1]
    else
      msg.send 'Please provied tag'
      return
    Instagram.tags.recent 
      name: "#{tag}"
      complete: (data) ->
        index = 1
        while index <= count
          msg.send data[index]['images']['standard_resolution']['url']
          index++

authenticate_user = () ->
  unless config.client_key
    msg.send "Please set the HUBOT_INSTAGRAM_CLIENT_KEY environment variable."
    return
  unless config.client_secret
    msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
    return

