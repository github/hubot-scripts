# Overlay funny things on people's faces
#
# hipster me <img> - Overlay hipster glasses on a face.
# clown me <img>   - Overlay a clown nose on a face.
# scumbag me <img> - Overlay a scumbag on a face.
# jason me <img> - Overlay a jason on a face.

module.exports = (robot) ->
  robot.respond /(hipster|clown|scumbag|rohan|jason)( me)? (.*)/i, (msg) ->
    type = msg.match[1]
    imagery = msg.match[3]

    if imagery.match /^https?:\/\//i
      msg.send "http://faceup.me/img?overlay=#{type}&src=#{imagery}"
    else
      imageMe msg, imagery, (url) ->
        msg.send "http://faceup.me/img?overlay=#{type}&src=#{url}"

imageMe = (msg, query, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      image  = msg.random images
      cb "#{image.unescapedUrl}"