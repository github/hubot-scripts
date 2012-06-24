# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot yo mama joke me - Returns a random Yo Mama joke
#
# Author:
#   victorbutler

module.exports = (robot) ->
  robot.respond /(yo\s?mama( joke)?)( me)?/i, (msg) ->
    yoMama msg, (url) ->
      msg.send url

yoMama = (msg, cb) ->
  msg.http('http://www.yomamajokesdb.com/random-joke/')
    .get() (err, res, body) ->
      cb body.match(/<div id="random">([^\<]+)<\/div>/)?[1] || "Sorry, this joke is very inappropriate (or could not be found)"

