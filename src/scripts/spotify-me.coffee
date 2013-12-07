# Description:
#   Search spotify for a song, and provide a link if found
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot spotify me (.*)
#
# Author:
#   bentona
#
getSong = (msg, query) ->
  msg.http("http://ws.spotify.com/search/1/track.json?q=#{query}")
    .get() (err, res, body) ->
      results = JSON.parse body
      num_results = results?.info?.num_results
      if num_results > 0
        response = results?.tracks?[0].href
      else
        response = "I couldn't find any songs :("
      msg.send(response)

module.exports = (robot) ->
  robot.respond /spotify me (.*)/i, (msg) ->
    getSong msg, msg.match[1]