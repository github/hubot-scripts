# Description:
#   Allows users to post a tweet to Twitter using common shared
#   Twitter accounts.
#
#   Requires a Twitter consumer key and secret, which you can get by
#   creating an application here: https://dev.twitter.com/apps
#
#   Based on KevinTraver's twitter.coffee script: http://git.io/iCQPyA
#
#   HUBOT_TWEETER_ACCOUNTS should be a string that parses to a JSON
#   object that contains access_token and access_token_secret for each
#   twitter screen name you want to allow people to use.
#
#   For example:
#   {
#     "hubot" : { "access_token" : "", "access_token_secret" : ""},
#     "github" : { "access_token" : "", "access_token_secret" : ""}
#   }
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
#   HUBOT_TWEETER_ACCOUNTS
#
# Author:
#   jhubert
#
# Repository:
#   https://github.com/jhubert/hubot-tweeter

Twit = require "twit"
config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  accounts: JSON.parse(process.env.HUBOT_TWEETER_ACCOUNTS)

unless config.consumer_key
  console.log "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
unless config.consumer_secret
  console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
unless config.accounts
  console.log "Please set the HUBOT_TWEETER_ACCOUNTS environment variable."

module.exports = (robot) ->
  robot.respond /tweet\@([^\s]+)$/i, (msg) ->
    msg.reply "You can't very well tweet an empty status, can ya?"
    return

  robot.respond /tweet\@([^\s]+)\s(.+)$/i, (msg) ->

    username = msg.match[1].toLowerCase()
    update   = msg.match[2].trim()

    unless config.accounts[username]
      msg.reply "I'm not setup to send tweets on behalf of #{msg.match[1]}. Sorry."
      return

    unless update and update.length > 0
      msg.reply "You can't very well tweet an empty status, can ya?"
      return

    twit = new Twit
      consumer_key: config.consumer_key
      consumer_secret: config.consumer_secret
      access_token: config.accounts[username].access_token
      access_token_secret: config.accounts[username].access_token_secret

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
