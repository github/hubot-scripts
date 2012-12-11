# Description:
#   Produces a random gangnam style gif
#
# Dependencies:
#   None
# Configuration:
#   None
#
# Commands:
#   hubot oppa gangnam style - Return random gif from gifbin.com
#
# Author:
#   EnriqueVidal

gifs = [
  "http://i1.kym-cdn.com/photos/images/original/000/370/936/cb3.gif",
  "http://i3.kym-cdn.com/photos/images/original/000/363/835/32a.gif",
  "http://knowyourmeme.com/photos/388760-gangnam-style",
  "http://i2.kym-cdn.com/photos/images/original/000/386/610/52d.gif"
  ]

module.exports = (robot)->
  robot.hear /oppa gangnam style/i, (message)-> #changed gifbin
    message.send message.random gifs
