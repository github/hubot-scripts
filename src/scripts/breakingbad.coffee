# Description:
#   Make hubot respond Breaking Bad style
#
# Dependencies:
#  None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   zachinglis
# 	keeran

module.exports = (robot) ->
  robot.hear /knock/i, (msg) ->
    msg.reply "I am the one who knocks!"

  robot.hear /magnet/i, (msg) ->
    msg.reply "Yeah Bitch! Magnets!"

  robot.hear /funyun/i, (msg) ->
    msg.reply "Funyuns are awesome!"

  robot.hear /science/i, (msg) ->
    msg.reply "Yeah, Mr. White! Yeah, science!"

  robot.hear /rocks/i, (msg) ->
    msg.reply "They're minerals Marie!"

  robot.hear /it'?s done/i, (msg) ->
    msg.reply "We're done when I say we're done."

  robot.hear /shops/i, (msg) ->
    msg.reply "Yo, gatorade me bitch!"
