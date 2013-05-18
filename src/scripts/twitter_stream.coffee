# Description
#   Filters out Twitter stream and displays tweets
#
# Dependencies:
#   "twit": "1.1.6"
#
# Configuration:
#   HUBOT_TWITTER_STREAM_CONSUMER_KEY
#   HUBOT_TWITTER_STREAM_CONSUMER_SECRET
#   HUBOT_TWITTER_STREAM_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot twitter stream <filter> - Connects to Twitter stream and filters tweets according to <filter> 
#   hubot stop twitter stream - Disconnects from Twitter stream
#
# Notes:
#   Only one stream can be active at the same time. The filter operates on the <track> parameter of
#   Twitter statuses/filter endpoint. See https://dev.twitter.com/docs/api/1.1/post/statuses/filter
#   for additional details.
#
# Author:
#   matteoagosti

Twit = require "twit"
config = 
  consumer_key: process.env.HUBOT_TWITTER_STREAM_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_STREAM_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_STREAM_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

module.exports = (robot) ->
  twit = undefined
  stream = undefined

  robot.respond /twitter stream (.*)/i, (msg) ->
    unless config.consumer_key
      msg.send "Please set the HUBOT_TWITTER_STREAM_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_STREAM_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_TWITTER_STREAM_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return

    filter = msg.match[1]
    unless filter
      msg.send "Please, specify the Twitter stream filter"
      return

    unless twit
      twit = new Twit config

    if stream
      stream.stop();

    stream = twit.stream("statuses/filter",
      track: filter
    )

    msg.send "Thank you, I'll filter out Twitter stream as requested: #{filter}"

    stream.on "tweet", (tweet) ->
      msg.send "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
    stream.on "disconnect", (disconnectMessage) ->
      msg.send "I've got disconnected from Twitter stream. Apparently the reason is: #{disconnectMessage}"
    stream.on "reconnect", (request, response, connectInterval) ->
      msg.send "I'll reconnect to Twitter stream in #{connectInterval}ms"
  
  robot.respond /stop twitter stream/i, (msg) ->
    if stream
      stream.stop()
    msg.send "Ok, I'm now disconnected from Twitter stream"