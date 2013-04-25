# Description:
# Make a slogan using sloganizer.net
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot slogan (.*)
#
# Author:
# DafyddCrosby
#

getSlogan = (msg, query) ->
  msg.http("http://www.sloganizer.net/en/outbound.php?slogan=#{query}")
    .get() (err, res, body) ->
      slogan = body.replace /<.*?>/g, ""
      msg.send slogan unless err

module.exports = (robot) ->
  robot.hear /slogan (.*)/i, (msg) ->
    getSlogan msg, msg.match[1]
