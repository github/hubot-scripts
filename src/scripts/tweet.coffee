# Description:
#   Display a random tweet from twitter about a subject
#
# Dependencies:
#    "ntwitter" : "https://github.com/sebhildebrandt/ntwitter/tarball/master",
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot <keyword> tweet - Returns a link to a tweet about <keyword>
#
# Notes:
#   There's an outstanding issue on AvianFlu/ntwitter#110 for search and the v1.1 API.
#   sebhildebrandt is a fork that is working, so we recommend that for now. This
#   can be removed after the issue is fixed and a new release cut, along with updating the dependency
#
# Author:
#   atmos, technicalpickles

ntwitter = require 'ntwitter'
inspect = require('util').inspect

module.exports = (robot) ->
  auth =
    consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
    consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
    access_token_key: process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
    access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

  twit = undefined

  robot.respond /(.+) tweet(\s*)?$/i, (msg) ->
    unless auth.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return
    unless auth.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return
    unless auth.access_token_key
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_KEY environment variable."
      return
    unless auth.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return


    twit ?= new ntwitter auth


    twit.verifyCredentials (err, data) ->
      if err
        msg.send "Encountered a problem verifying twitter credentials :(", inspect err
        return

      q = escape(msg.match[1])
      twit.search q, (err, data) ->
        if err
          msg.send "Encountered a problem twitter searching :(", inspect err
          return

        if data.statuses? and data.statuses.length > 0
          status = msg.random data.statuses
          msg.send "http://twitter.com/#!/#{status.user.screen_name}/status/#{status.id_str}"
        else
          msg.reply "No one is tweeting about that."
