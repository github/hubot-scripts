# Description:
#   gets tweet from user
#
# Dependencies:
#   "twit": "1.1.6"
#   "underscore": "1.4.4"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY_<USERNAME>
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET_<USERNAME>
#
# Commands:
#   hubot twitter <twitter username> - Show last tweet from <twitter username>
#   hubot twitter <twitter username> <n> - Cycle through tweet with <n> starting w/ latest
#
# Author:
#   KevinTraver
#

_ = require "underscore"
Twit = require "twit"
twitterConfig = require("hubot-twitter-config")(process.env)

module.exports = (robot) ->
  auth = twitterConfig.defaultCredentials

  robot.respond /(twitter|lasttweet)\s+(\S+)\s?(\d?)/i, (msg) ->
    unless auth
      msg.reply "Please set HUBOT_TWITTER_CONSUMER_KEY_<USERNAME> and HUBOT_TWITTER_CONSUMER_SECRET_<USERNAME>."
      return

    twit = new Twit(auth)

    username = msg.match[2]
    if msg.match[3] then count = msg.match[3] else count = 1

    twit.get "statuses/user_timeline",
      screen_name: escape(username)
      count: count
      include_rts: false
      exclude_replies: true
    , (err, reply) ->
      return msg.send "Error" if err
      return msg.send _.unescape(_.last(reply)['text']) if reply[0]['text']
