# Description:
#   Detect tweet URL and send tweet content
#
# Dependencies:
#  "ntwitter": "0.2.10"
#  "underscore": "1.5.1"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME>
#
# Commands:
#   None
#
# Author:
#   Vrtak-CZ, kdaigle

ntwitter = require 'ntwitter'
_ = require 'underscore'
twitterConfig = require("../twitter-config")(process.env)

module.exports = (robot) ->
  auth = twitterConfig.defaultCredentials()
  unless auth
    console.log "Please set HUBOT_TWITTER_CONSUMER_KEY_<USERNAME> and HUBOT_TWITTER_CONSUMER_SECRET_<USERNAME>."
    return

  twit = new ntwitter auth

  robot.hear /https?:\/\/(mobile\.)?twitter\.com\/.*?\/status\/([0-9]+)/i, (msg) ->
    twit.getStatus msg.match[2], (err, tweet) ->
      if err
        console.log err
        return

      tweet_text = _.unescape(tweet.text)
      if tweet.entities.urls?
        for url in tweet.entities.urls
          tweet_text = tweet_text.replace(url.url, url.expanded_url)
      if tweet.entities.media?
        for media in tweet.entities.media
          tweet_text = tweet_text.replace(media.url, media.media_url)

      msg.send "@#{tweet.user.screen_name}: #{tweet_text}"
