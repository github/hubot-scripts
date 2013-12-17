# Description:
#   Allows users to post a tweet to Twitter using common shared
#   Twitter accounts.
#
#   Requires a Twitter consumer key and secret, which you can get by
#   creating an application here: https://dev.twitter.com/apps
#
#   Based on KevinTraver's twitter.coffee script: http://git.io/iCQPyA
#
#   See here for environment variable descriptions:
#   https://github.com/github/hubot-scripts/tree/master/src/twitter-config.coffee
#
#   This also can be installed as an npm package: hubot-tweeter
#
# Commands:
#   hubot tweet@<screen_name> <update> - posts the update to twitter as <screen_name>
#
# Dependencies:
#   "twit": "1.1.8"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME1>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME1>
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME2>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME2>
#   ...
#
# Author:
#   jhubert
#
# Repository:
#   https://github.com/jhubert/hubot-tweeter

Twit = require "twit"
twitterConfig = require("../twitter-config")(process.env)

module.exports = (robot) ->
  robot.respond /tweet\@([^\s]+)$/i, (msg) ->
    msg.reply "You can't very well tweet an empty status, can ya?"
    return

  robot.respond /tweet\@([^\s]+)\s(.+)$/i, (msg) ->
    username = msg.match[1].toLowerCase()
    credentials = twitterConfig.credentialsFor(username)
    unless credentials
      capsUsername = username.toUpperCase()
      msg.reply "Please set HUBOT_TWITTER_CONSUMER_KEY_#{capsUsername} and HUBOT_TWITTER_CONSUMER_SECRET_#{capsUsername}."
      return

    update = msg.match[2].trim()
    unless update and update.length > 0
      msg.reply "You can't very well tweet an empty status, can ya?"
      return

    twit = new Twit(credentials)

    twit.post "statuses/update",
      status: update
    , (err, reply) ->
      if err
        data = JSON.parse(err.data).errors[0]
        msg.reply "I can't do that. #{data.message} (error #{data.code})"
        return
      if reply['text']
        return msg.send "#{reply['user']['screen_name']} just tweeted: #{reply['text']}"
      else
        return msg.reply "Hmmm.. I'm not sure if the tweet posted. Check the account: http://twitter.com/#{username}"
