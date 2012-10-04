# Description:
#   Continuously searches Twitter for mentions of a specified string.
#
# Commands:
#   hubot set twitter query <search_term> - Set search query
#   hubot show twitter query - Show current search query
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TWITTER_MENTION_QUERY
#   HUBOT_TWITTER_MENTION_ROOM
#
# Author:
#   Sachinr

module.exports = (robot) ->
  response = new robot.Response(robot)
  room = process.env.HUBOT_TWITTER_MENTION_ROOM
  robot.brain.data.twitter_mention ?= {}

  setInterval ->
    last_tweet = robot.brain.data.twitter_mention.last_tweet || ''

    if twitter_query(robot)?
      response.http('http://search.twitter.com/search.json')
        .query(q: escape(twitter_query(robot)), since_id: last_tweet)
        .get() (err, res, body) ->
          tweets = JSON.parse(body)
          if tweets.results? and tweets.results.length > 0
            robot.brain.data.twitter_mention.last_tweet = tweets.results[0].id_str
            for tweet in tweets.results.reverse()
              message = "http://twitter.com/#!/#{tweet.from_user}/status/#{tweet.id_str}"
              robot.messageRoom room, message
  , 1000 * 60 * 5

  robot.respond /(set twitter query) (.*)/i, (msg) ->
    robot.brain.data.twitter_mention.query = msg.match[2]
    robot.brain.data.twitter_mention.last_tweet = ''
    msg.send "I'm now searching Twitter for: #{twitter_query(robot)}"

  robot.respond /(show twitter query)/i, (msg) ->
    msg.send "I'm searching Twitter for: #{twitter_query(robot)}"

twitter_query = (robot) ->
  robot.brain.data.twitter_mention.query ||
    process.env.HUBOT_TWITTER_MENTION_QUERY
