# Description
#   random cat gifs as a service for your cat gif driven development
#   source for the service: https://github.com/flores/moarcats
#   most of the below is lifted from corgime.coffee
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot moarcats me - links http://edgecats.net, which serves a random cat gif
#   hubot moarcats bomb <n> - gives <n> cat gifs
#
# Author:
#   flores

module.exports = (robot) ->
  robot.respond /moarcats me/i, (msg) ->
    msg.http("http://edgecats.net/random").get() (err, res, body) ->
      msg.send body

  robot.respond /moarcats bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    for cat in [1..count]
      msg.http("http://edgecats.net/random")
        .get() (err, res, body) ->
          msg.send body
