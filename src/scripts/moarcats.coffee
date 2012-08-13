# Description
#   random cat gifs as a service for your cat gif driven development
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot moarcat - links http://lo.no.de, which serves a random cat gif
#
# Author:
#   flores

module.exports = (robot) ->
  robot.respond /moarcat/i, (msg) ->
    msg.send "http://lo.no.de"
