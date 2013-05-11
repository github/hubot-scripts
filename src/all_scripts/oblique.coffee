# Description:
#   Display an oblique strategy
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot strategy - Returns an oblique strategy
#
# Author:
#   hakanensari

module.exports = (robot) ->
  robot.respond /\W*(?:an? )?(?:oblique )?strategy\??$/i, (msg) ->
    msg.http('http://oblique.io')
      .get() (err, res, body) ->
        msg.send JSON.parse body
