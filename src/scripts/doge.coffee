# Description
#   Creates a Doge image with your phrase
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot doge <phrase> - get a doge image with your phrase
#
# Author:
#   sushithegreat
#
# Contributor:
#   benhamill

module.exports = (robot) ->

  robot.respond /doge (.*)$/i, (msg) ->
    phrase = msg.match[1].replace(/[\s]+/g, '/')
    msg.send "http://dogesay.com/wow////" + phrase
