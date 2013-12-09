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
#   hubot spotify me <track> - Search spotify and return a link to a track
#
# Author:
#   bentona
#
# Notes:
#  TODO: Add territory filtering so we only link songs that you can actually play
#
getHTTPLinkFromSpotifyURL = (spotifyLink) ->
  # links are returned in the format
  # spotify:(track|artist|album):7cy1bEJV6FCtDaYpsk8aG6
  # so we need to convert this to, i.e. track/7cy1bEJV6FCtDaYpsk8aG6
  linkComponents = spotifyLink.split(':')
  formattedParams = linkComponents[1..2].join('/')
  "http://open.spotify.com/#{formattedParams}"

getSong = (msg, query) ->
  msg.http("http://ws.spotify.com/search/1/track.json?q=#{query}")
    .get() (err, res, body) ->
      if err?
        msg.reply "Ran into an error trying to spotify: #{err}"
        return
      else if res.statusCode isnt 200
        msg.reply "Got back HTTP #{res.statusCode} trying to spotify: #{body}"
        return
      else
        results = JSON.parse body
        numResults = results?.info?.numResults or 0
        if numResults > 0
          response = getHTTPLinkFromSpotifyURL(results?.tracks?[0].href)
        else
          response = "I couldn't find any songs :("
        msg.send(response)

module.exports = (robot) ->
  robot.respond /spotify me (.*)/i, (msg) ->
    getSong msg, msg.match[1]