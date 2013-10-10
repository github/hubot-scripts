# Description:
#   Returns clip art images from openclipart.org API.
#
# Commands:
#   hubot clipart me <query> - Queries openclipart for <query> and returns a random result.

module.exports = (robot) ->
  robot.respond /(clipart)( me)? (.*)/i, (msg) ->
    clipartMe msg, msg.match[3], (url) ->
      msg.send url

clipartMe = (msg, query, cb) ->
  q = query: query

  msg.http('http://openclipart.org/search/json/')
    .query(q)
    .get() (err, res, body) ->
      data = JSON.parse(body)
      images = data.payload
      if images?.length > 0
        image  = msg.random images
        cb "#{image.svg.png_full_lossy}"

