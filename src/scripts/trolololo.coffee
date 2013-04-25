# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_IMGUR_CLIENT_ID
#
# Commands:
#   trol.* - returns one of many alternative trollfaces when trolling is
#   mentioned (troll, trolling, trolololololo...)
#
# Author:
#   ajacksified


https = require('https')

options =
  hostname: 'api.imgur.com'
  path: '/3/album/pTXm0'
  headers:
    'Authorization': "Client-ID #{process.env.HUBOT_IMGUR_CLIENT_ID}"

module.exports = (robot) ->
  robot.hear /\btrol\w+?\b/i, (msg) ->
    data = []

    https.get(options, (res) ->
      if res.statusCode == 200
        res.on 'data', (chunk) ->
          data.push(chunk)

        res.on 'end', () ->
          parsedData = JSON.parse(data.join(''))
          images = parsedData.data.images
          image = images[parseInt(Math.random() * images.length)]

          msg.send(image.link)
    )

