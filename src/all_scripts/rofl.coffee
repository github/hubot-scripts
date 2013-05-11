# Description:
#   Get a random ROFL image - warning, this includes NSFW content!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Author:
#   mcminton ripped from john-griffin

module.exports = (robot) ->

  robot.hear /rofl/i, (msg) ->
    msg.http("http://serene-beyond-2652.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).rofl
