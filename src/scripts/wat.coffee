# Description:
#   Get a random WAT image - warning, this includes NSFW content!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot wat - Random WAT
#
# Author:
#   john-griffin

module.exports = (robot) ->

  robot.respond /wat/i, (msg) ->
    msg.http("http://watme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).wat
