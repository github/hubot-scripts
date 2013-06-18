# Description:
#   Detect tweet URL and send tweet content
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Dependencies:
#  "ntwitter" : "0.2.10",
#
# Commands:
#   None
#
# Author:
#   Vrtak-CZ, kdaigle

ntwitter = require 'ntwitter'

module.exports = (robot) ->
  auth =
    consumer_key:           process.env.HUBOT_TWITTER_CONSUMER_KEY,
    consumer_secret:        process.env.HUBOT_TWITTER_CONSUMER_SECRET,
    access_token_key:       process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY,
    access_token_secret:    process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET,
    rest_base:              'https://api.twitter.com/1.1'

  if not auth.consumer_key or not auth.consumer_secret or not auth.access_token_key or not auth.access_token_secret
    console.log "twitter-content.coffee: HUBOT_TWITTER_CONSUMER_KEY, HUBOT_TWITTER_CONSUMER_SECRET,
    HUBOT_TWITTER_ACCESS_TOKEN_KEY, and HUBOT_TWITTER_ACCES_TOKEN_SECRET are required."
    return

  twit = new ntwitter auth

  robot.hear /https?:\/\/(mobile\.)?twitter\.com\/.*?\/status\/([0-9]+)/i, (msg) ->
    twit.getStatus msg.match[2], (err, tweet) ->
      if err
        console.log err
        return

      msg.send "@#{tweet.user.screen_name}: #{tweet.text}"
