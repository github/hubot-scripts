# Description:
#   When in Austin
#
# Dependencies:
#   "jsdom": "0.2.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot when in austin - Pull a random entry from wheninatx.tumblr.com
#
# Author:
#   elliotttf

http = require 'http'
jsdom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /when(\s)?in(\s)?austin/i, (msg) ->
    options =
      host: 'wheninatx.tumblr.com',
      port: 80,
      path: '/random'

    # Random redirects us to another article, grab that url and respond.
    http.get options, (res) ->
      location = res.headers.location
      jsdom.env location, [ 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js' ], (errors, window) ->
        (($) ->
          title = $('meta[property="og:title"]').attr('content')
          img = $('article p[align="center"] img').attr('src')

          msg.send title + ' ' + img
        )(window.jQuery)

