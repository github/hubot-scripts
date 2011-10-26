# Display a random tweet from twitter about a subject
#
# <robot_name> tweet me <query> - Returns a random link to a tweet about <query>

module.exports = (robot) ->
  robot.respond /(tweet)( me)? (.*)/i, (msg) ->
    query = escape(msg.match[3])
    msg.http('http://search.twitter.com/search.json')
      .query(q: query)
      .get() (err, res, body) ->
        tweets = JSON.parse(body)

        if tweets.results? and tweets.results.length > 0
          tweet = msg.random tweets.results
          msg.send "http://twitter.com/#!/#{tweet.from_user}/status/#{tweet.id_str}"
