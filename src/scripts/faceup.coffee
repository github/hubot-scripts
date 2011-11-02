# Overlay funny things on people's faces
#
# hipster me <img> - Overlay hipster glasses on a face.
# clown me <img>   - Overlay a clown nose on a face.
# scumbag me <img> - Overlay a scumbag on a face.
# jason me <img> - Overlay a scumbag on a face.

escape = require('querystring').escape

module.exports = (robot) ->
  robot.respond /(hipster|clown|scumbag|rohan|jason)( me)? (.*)/i, (msg) ->
    type = msg.match[1]
    url = escape msg.match[3]
    msg.send "http://faceup.me/img?overlay=#{type}&src=#{url}#.png"