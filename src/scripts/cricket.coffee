# Description:
#   Display cricket scores for current live games
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cricket scores for <team> - Returns the current score of live game
#   hubot cricket scores for all - Returns the current score of all live games
#
# Author:
#   adtaylor

module.exports = (robot) ->
  feed_url = "http://query.yahooapis.com/v1/public/yql?q=select%20title%20from%20rss%20where%20url%3D%22http%3A%2F%2Fstatic.cricinfo.com%2Frss%2Flivescores.xml%22&format=json&diagnostics=true&callback="
  prefix = "CRICKET SCORE: "
  robot.respond /cricket scores for (.*)/i, (msg) ->
    query = msg.match[1]?.toUpperCase()
    msg.http(feed_url)
      .get() (err, res, body) ->
        results = JSON.parse body
        scores = results.query.results?.item
        if not scores then return msg.send prefix + "No games currently in progress."
        if query is "ALL"
          scores.forEach (score)->
            msg.send prefix + score.title
        else
          scores.forEach (score)->
            if score.title.toUpperCase().search(query) isnt -1 then msg.send prefix + score.title

  robot.respond /do you like cricket?(.*)/i, (msg) ->
    msg.send "No, I love it!"
