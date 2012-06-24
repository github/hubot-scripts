# Description:
#   Display a "deal with it" gif
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   deal with it - display a "deal with it" gif
#
# Author:
#   brianstanwyck

deal = [
  "http://i.imgur.com/ykDuU.gif",
  "http://i.imgur.com/3PWHn.gif",
  "http://i.imgur.com/sEinL.gif",
  "http://i.imgur.com/zsK7e.gif",
  "http://i.imgur.com/rE2aH.gif",
  "http://i.imgur.com/Wj3Do.gif"
]

module.exports = (robot) ->
  robot.hear /deal with it/i, (msg)->
    msg.send msg.random deal
