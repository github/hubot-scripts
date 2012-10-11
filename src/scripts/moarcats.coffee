# Description
#   random cat gifs as a service for your cat gif driven development
#   source for the service: https://github.com/flores/moarcats
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot moarcat - links http://edgecats.net, which serves a random cat gif
#
# Author:
#   flores

module.exports = (robot) ->
  robot.respond /moarcat/i, (msg) ->
    msg.send "http://edgecats.net/random"
