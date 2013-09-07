# Description:
#   Quick description for goo.gl URLs
#
# Dependencies:
#   "googleapis": "0.4.3"
#
# Configuration:
#   None
#
# Commands:
#   Shows the destination of any mentioned goo.gl URLs.
#
# Author:
#   monokrome

googleapis = require 'googleapis'

module.exports = (robot) ->
  shortener = googleapis.discover 'urlshortener', 'v1'

  startListening = (err, client) ->
    robot.hear /goo\.gl\/[\w\d]+/, (msg) ->
      url = msg.match[0]

      request = client.urlshortener.url.get
        shortUrl: 'http://' + url

      request.execute (err, response) ->
        unless err
          msg.send 'Shortened URL (' + url + ') is ' + response.longUrl

  shortener.execute startListening
