# Last (or current) played song by a user in Last.fm
#
# hubot <what's playing> someone - Returns song name and artist
#

module.exports = (robot) ->
  robot.respond /what's playing (.*)/i, (msg) ->
    user = escape(msg.match[1])
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
