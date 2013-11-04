# Description:
#   Cute me is a way to get pictures of cute things
#
# Dependencies:
#   "underscore" : http://underscorejs.org/
#
# Configuration:
#   None
#
# Commands:
#   hubot cute me - Receive a cute thing
#   hubot eye bleach - Receieve a cute thing

_ = require 'underscore'

module.exports = (robot) ->

  robot.respond /cute me/i, (msg) ->
    cuteMe(msg)

  robot.hear /eye bleach/i, (msg) ->
    cuteMe(msg)

  cuteMe = (msg) ->
    msg.http("http://api.dailycute.net/v1/posts/all.json")
      .get() (err, res, body) ->
        results = JSON.parse(body)
        msg.send _.sample(results.posts).image_src


