# Description:
#   Applause from Orson Welles
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   (applause|applaud|bravo|slow clap) - Get applause
#
# Author:
#   joshfrench

module.exports = (robot) ->
  robot.hear /applau(d|se)|bravo|slow clap/i, (msg) ->
    msg.send "http://i.imgur.com/9Zv4V.gif"