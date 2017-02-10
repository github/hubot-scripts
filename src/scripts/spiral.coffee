# Description:
#   Spiral Fetch
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   spiral - Display a random set of spirals
#
# Author:
#   pingles - modified by charles267 to accomodate spirals

spirals = [
  "http://stream1.gifsoup.com/view3/4015219/mowgli-hypnosis-o.gif",
  "https://media.giphy.com/media/koOK5F0f1uGDC/giphy.gif",
  "https://media.giphy.com/media/N7CN0bacImyg8/giphy.gif",
  "https://media.giphy.com/media/crxrrH7b3QQjC/giphy.gif",
  "https://media.giphy.com/media/1ktFzqRoFtXK8/giphy.gif"
]

module.exports = (robot) ->
  robot.hear /\b(spiral|hypnosis)\b/i, (msg) ->
msg.send msg.random spirals
