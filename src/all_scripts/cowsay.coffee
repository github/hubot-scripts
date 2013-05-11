# Description:
#   Cowsay.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cowsay <statement> - Returns a cow that says what you want
#
# Author:
#   brettbuddin

module.exports = (robot) ->
  robot.respond /cowsay( me)? (.*)/i, (msg) ->
    msg
      .http("http://cowsay.morecode.org/say")
      .query(format: 'text', message: msg.match[2])
      .get() (err, res, body) ->
        msg.send body
