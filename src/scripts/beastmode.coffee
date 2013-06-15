# Description
#   Listens for beastmode.fm track urls and returns track title and cover art
#
# Dependencies:
#   "jsdom": "~0.2.13"
#
# Configuration:
#   None
#
# Commands:
#   {beastmodefm-url} - Return track title and cover art
#
# Notes:
#
#
# Author:
#   benpink

jsdom = require 'jsdom'
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js'

module.exports = (robot) ->

  robot.hear /beastmode.fm.*?(\/(\d+))/i, (msg) ->
    robot.http('http://beastmode.fm/track/' + msg.match[2])
      .get() (err, res, body) ->
        jsdom.env body, [jquery], (errors, window) ->
          trackImg    = window.$('#track-img img').attr('src')
          trackTitle  = window.$('#article-info h1').text()
          msg.send trackTitle + ' ' + trackImg
