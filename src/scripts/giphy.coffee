# Description:
#   A way to search images on giphy.com
#
# Commands:
#   hubot gif me <query> - Returns an animated gif matching the requested search term.

module.exports = (robot) ->
  robot.respond /(gif|giphy)( me)? (.*)/i, (msg) ->
    giphyMe msg, msg.match[3], (url) ->
      msg.send url

giphyMe = (msg, query, cb) ->
  q = q: query
  msg.http('http://giphy.com/api/gifs/search')
    .query(q)
    .get() (err, res, body) ->
      response = JSON.parse(body)
      images = response.data.gifs
      if images.length > 0
        image = msg.random images
        cb image.original_url