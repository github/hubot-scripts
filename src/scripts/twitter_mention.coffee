# Description:
#   Continuously searches Twitter for mentions of a specified string.
#
#   Requires a Twitter consumer key and secret, which you can get by 
#   creating an application here: https://dev.twitter.com/apps
#
# Commands:
#   hubot twitter search <search_term> - Set search query
#   hubot twitter search - Show current search query
#
# Dependencies:
#   oauth
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_MENTION_QUERY
#   HUBOT_TWITTER_MENTION_ROOM
#
# Author:
#   timdorr

oauth = require 'oauth'


twitter_bearer_token = null

module.exports = (robot) ->
  robot.brain.data.twitter_mention ?= {}

  key = process.env.HUBOT_TWITTER_CONSUMER_KEY
  secret = process.env.HUBOT_TWITTER_CONSUMER_SECRET
  if not key or not secret
    console.log "twitter_mention.coffee: HUBOT_TWITTER_CONSUMER_KEY and HUBOT_TWITTER_CONSUMER_SECRET are required. Get your tokens here: https://dev.twitter.com/apps"
    return

  twitterauth = new oauth.OAuth2(key, secret, "https://api.twitter.com/", null, "oauth2/token", null)

  twitterauth.getOAuthAccessToken "", {grant_type:"client_credentials"}, (e, access_token, refresh_token, results) ->
    twitter_bearer_token = access_token
    twitter_setup_search robot

  robot.respond /twitter search (.*)/i, (msg) ->
    robot.brain.data.twitter_mention.query = msg.match[1]
    robot.brain.data.twitter_mention.last_tweet = ""
    msg.send "Now searching Twitter for: #{twitter_query(robot)}"

  robot.respond /twitter search$/i, (msg) ->
    msg.send "Searching Twitter for: #{twitter_query(robot)}"


twitter_query = (robot) ->
  robot.brain.data.twitter_mention.query ||
    process.env.HUBOT_TWITTER_MENTION_QUERY


twitter_setup_search = (robot) ->
  if not twitter_bearer_token
    console.log "Invalid Twitter consumer key/secret!"
    return
  
  setInterval ->
    if twitter_query(robot)?
      twitter_search(robot)
  , 1000 * 60 * 1

  if twitter_query(robot)?
    twitter_search(robot)


twitter_search = (robot) ->
  last_tweet = robot.brain.data.twitter_mention.last_tweet || ''

  robot.http("https://api.twitter.com/1.1/search/tweets.json")
    .header("Authorization", "Bearer #{twitter_bearer_token}")
    .query(q: escape(twitter_query(robot)), since_id: last_tweet)
    .get() (err, response, body) ->
      tweets = JSON.parse(body)
      if tweets.statuses? and tweets.statuses.length > 0
        robot.brain.data.twitter_mention.last_tweet = tweets.statuses[0].id_str
        for tweet in tweets.statuses.reverse()
          message = "Tweet: #{tweet.text} - @#{tweet.user.screen_name} http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
          robot.messageRoom process.env.HUBOT_TWITTER_MENTION_ROOM, message
