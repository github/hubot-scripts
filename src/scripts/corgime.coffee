# Corgime
#
# corgi me - Receive a corgi
# corgi bomb N - get N corgis

module.exports = (robot) ->

  robot.respond /corgi me/i, (msg) ->
    msg.http("http://corgibomb.heroku.com/random")
      .get() (err, res, body) ->
        msg.send body

  robot.respond /corgi bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    msg.http("http://corgibomb.heroku.com/bomb/" + count)
      .get() (err, res, body) ->
        msg.send corgi for corgi in JSON.parse(body)
