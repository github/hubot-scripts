# cat me - Receive a cat
# cat bomb N - get N cats

# Description:
#   Catme is the most important thing in your life, even more so than pugs!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cat me - Receive a cat
#   hubot cat bomb N - get N cats

module.exports = (robot) ->

  robot.respond /cat me/i, (msg) ->
    msg.http("http://meowme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).cat

  robot.respond /cat bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    msg.http("http://meowme.herokuapp.com/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send cat for cat in JSON.parse(body).cats

  robot.respond /how many cats are there/i, (msg) ->
    msg.http("http://meowme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).cat_count} cats."
