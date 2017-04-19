# Description:
#   A way to search images on GifGif  (http://gifgif.media.mit.edu)
#
# Dependencies:
#   "fuzzy": "0.1.0"
#
# Configuration:
#   HUBOT_GIFGIF_API_KEY
#
# Commands:
#   gifgif <query> - Returns an animated gif matching the requested query.
#
# Author:
#   justindowning

fuzzy = require('fuzzy')

gifgif =
  api_key: process.env.HUBOT_GIFGIF_API_KEY
  api_url: 'http://gifgif.media.mit.edu/api'

emotions = [
             "amusement",
             "anger",
             "contempt",
             "contentment",
             "disgust",
             "embarrassment",
             "excitement",
             "fear",
             "guilt",
             "happiness",
             "pleasure",
             "pride",
             "relief",
             "sadness",
             "satisfaction",
             "shame",
             "surprise"
           ]

module.exports = (robot) ->
  robot.hear /^gifgif (\w+)/i, (msg) ->
    query = msg.match[1]
    results = fuzzy.filter(query, emotions)
    matches = results.map (x) -> x.string
    if matches.length > 0
      emotion = msg.random matches
      msg.http("#{gifgif.api_url}/results")
        .query(emotion: emotion, key: gifgif.api_key)
        .get() (err, res, body) ->
          gifs = JSON.parse(body).response.results
          if gifs.length > 0
            image = msg.random gifs
            msg.send image.embedLink
          else
            msg.send "Dang! Couldn't find a gif!"
    else
      msg.send "Valid emotions include: #{emotions}"
