# Description:
#   Search spotify for a song, and provide a link if found
#   TODO: Add territory filtering so we only link songs
#   that you can actually play
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot spotify me <track> - Search spotify and return a link to a track
#
# Author:
#   bentona
#
getHTTPLinkFromSpotifyURL = (spotifyLink) ->
  "http://open.spotify.com/" + spotifyLink.split(':')[1..2].join('/')

getSong = (msg, query) ->
  msg.http("http://ws.spotify.com/search/1/track.json?q=#{query}")
    .get() (err, res, body) ->
      results = JSON.parse body
      num_results = results?.info?.num_results
      if num_results > 0
        response = getHTTPLinkFromSpotifyURL(results?.tracks?[0].href)
      else
        response = "I couldn't find any songs :("
      msg.send(response)

module.exports = (robot) ->
  robot.respond /spotify me (.*)/i, (msg) ->
    getSong msg, msg.match[1]