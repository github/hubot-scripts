# Allows hubot follow a user on twitter.
#
# Set the HUBOT_TWITTER_USER environment var to your twitter username
# and HUBOT_TWITTER_PASSWORD to your password
#
# follow <twitter_user_id> - Follows a user on twitter.

TwitterNode = require('twitter-node').TwitterNode

twit = new TwitterNode(
  user: process.env.HUBOT_TWITTER_USER
  password: process.env.HUBOT_TWITTER_PASSWORD
)

# Make sure you listen for errors, otherwise they are thrown
twit.addListener "error", (error) ->
  # console.log error.message

module.exports = (robot) ->
  robot.respond /follow (.*)$/i, (msg) ->
    twit.follow msg.match[1]

    twit.addListener("tweet", (tweet) ->
      msg.reply "@" + tweet.user.screen_name + ": " + tweet.text
    ).addListener("limit", (limit) ->
      msg.reply "LIMIT: " + sys.inspect(limit)
    ).addListener("delete", (del) ->
      msg.reply "DELETE: " + sys.inspect(del)
    ).addListener("end", (resp) ->
      msg.reply "wave goodbye... " + resp.statusCode
    ).stream()

