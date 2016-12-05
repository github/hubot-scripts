# Description:
#   Clearly illustrate with an image what people mean whenever they say "facepalm"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   jimeh

module.exports = (robot) ->
  robot.hear /facepalm/i, (msg) ->
    # Randomly use facepalm.org or a Google Image search for "facepalm".
    imageMe msg, "facepalm", (url) ->
        msg.send url

imageMe = (msg, query, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query, safe: 'active')
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      if images.length > 0
        image  = msg.random images
        cb "#{image.unescapedUrl}#.png"
