# Get a random WAT image - warning, this includes NSFW content!
#
# hubot wat - Random WAT

module.exports = (robot) ->

  robot.respond /wat/i, (msg) ->
    msg.http("http://watme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).wat
