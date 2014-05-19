# Description:
#   Displays the description for the requested error code.
#
# Dependencies:
#   jsdom, jquery
#
# Configuration:
#   None
#
# Commands:
#   hubot http status ###
#
# Author:
#   delianides
#

jsdom = require "jsdom"
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js'

module.exports = (robot) ->
  robot.respond /http status (.*)/i, (msg) ->
    httpCode = msg.match[1]
    msg
      .http('http://en.wikipedia.org/wiki/List_of_HTTP_status_codes')
      .get() (err, res, body) ->
        jsdom.env body, [jquery], (errors, window) ->
          statusCode = window.$('#'+httpCode).parent().text()
          if statusCode
            msg.send statusCode
            msg.send "http://en.wikipedia.org/wiki/List_of_HTTP_status_codes##{httpCode}"
          else
            msg.send "HTTP status code '#{httpCode}' doesn't exist. Ironically, this would be HTTP Error 404."
