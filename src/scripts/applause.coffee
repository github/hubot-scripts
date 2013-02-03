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

images = [
  "http://i.imgur.com/9Zv4V.gif",
  "http://assets0.ordienetworks.com/images/GifGuide/clapping/1292223254212-dumpfm-mario-Obamaclap.gif",
  "http://sunglasses.name/gif/joker-clap.gif",
  "http://www.reactiongifs.com/wp-content/uploads/2013/01/applause.gif"
  ]


module.exports = (robot) ->
  robot.hear /applau(d|se)|bravo|slow clap/i, (msg) ->
    msg.send msg.random images
