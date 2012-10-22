#
# Description:
#   Last (or current) played song by a user in Last.fm
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_LASTFM_APIKEY
#
# Commands:
#   hubot what's <last FM user> playing  - Returns song name and artist
#   hubot what am I playing - only works if last.fm nick = username who typed it
#
# Author:
#   guilleiguaran
#   sn0opy

getSong = (msg, usr) ->
  user = usr ? msg.match[2]
  apiKey = process.env.HUBOT_LASTFM_APIKEY
  msg.http('http://ws.audioscrobbler.com/2.0/?')
    .query(method: 'user.getrecenttracks', user: user, api_key: apiKey, format: 'json')
    .get() (err, res, body) ->
      results = JSON.parse(body)
      if results.error
        msg.send results.message
        return
      song = results.recenttracks.track[0]
      msg.send "#{song.name} by #{song.artist['#text']}"

module.exports = (robot) ->
  robot.respond /what(')?s (.*) playing/i, (msg) ->
    getSong(msg)
  robot.respond /what am I playing/i, (msg) ->
    getSong(msg, msg.message.user.name)
