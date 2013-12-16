# Description:
#   Normalized Twitter integration for hubot
#
# Notes
#   Scripts can access an ntwitter object that's authenticated via `robot.twitter`.
#   They should check that it's defined first though.
#
#   Named 1-twitter.coffee for load order
#
# Dependencies:
#    "ntwitter" : "https://github.com/sebhildebrandt/ntwitter/tarball/master",
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME>

ntwitter = require 'ntwitter'
util = require "util"
twitterConfig = require("../twitter-config")(process.env)

module.exports = (robot) ->
  credentials = twitterConfig.defaultCredentials()

  if not credentials
    robot.logger.warning "[twitter] Missing Twitter configuration, disabling twitter support : HUBOT_TWITTER_CONSUMER_KEY, HUBOT_TWITTER_CONSUMER_SECRET, HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME>, and HUBOT_TWITTER_ACCES_TOKEN_SECRET_<USERNAME> are required."
  else
    credentials.rest_base = 'https://api.twitter.com/1.1'
    robot.twitterAuth = credentials
    robot.twitter = new ntwitter credentials
    robot.twitter.verifyCredentials (err, data) ->
      if err
        robot.logger.warning "[twitter] Error verifying credentials, disabling twitter support: #{util.inspect err}"
        robot.twitter = undefined
      else
        robot.logger.info "[twitter] connected as #{data.screen_name}"

  robot.respondWithTwitterUsersRandomStatus = (regex, screen_name) ->
    robot.respond regex, (msg) ->
      unless robot.twitter
        msg.send "Couldn't connect to twitter :("
        return

      robot.twitter.getUserTimeline {screen_name: screen_name}, (err, data) ->
        if err
          msg.send "Encountered a problem getting #{screen_name}'s timeline", util.inspect(err)
          return

        status = msg.random data
        msg.send "http://twitter.com/#!/#{status.user.screen_name}/status/#{status.id_str}"
