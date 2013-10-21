# Description:
#   Show a "Srsly Guise" gif when someone says "Seriously Guys" or "Srsly Guise"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   srsly guise/srsly guys/seriously guise/seriously guys - Display a Srsly Guise gif
#
# Author:
#   keithamus

images = [
  "http://i.imgur.com/0lyao5E.gif",
  "http://i.imgur.com/0lyao5E.gif",
  "http://i.imgur.com/0lyao5E.gif",
  "http://i.imgur.com/xU7AhQh.gif",
  "http://i.imgur.com/dpFlIMx.gif",
  "http://i.imgur.com/mE2oDmm.gif",
  "http://i.imgur.com/ersspRE.gif"
]

module.exports = (robot) ->
  robot.hear /s(rsly|eriously) gu(?:ise|ys)/i, (msg) ->
    msg.send msg.random images
