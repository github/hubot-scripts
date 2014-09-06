# Description:
#   Kanyeclap
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot kanyeclap - kanye will clap for you!
#
# Author:
#   maju6406

kanyes = [
  "http://i.imgur.com/JOMnW9a.gif"
]

module.exports = (robot) ->
  robot.hear /kanyeclap/i, (msg) ->
    msg.send msg.random kanyes
