# Description:
#   Return random animated GIFs from giftv
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot giftv me - Returns a random animated GIF
#
# Author:
#   brettbuddin

module.exports = (robot) ->
  robot.respond /giftv( me)?$/i, (msg) ->
    msg
      .http('http://www.gif.tv/gifs/get.php')
      .get() (err, res, body) ->
        msg.send 'http://www.gif.tv/gifs/' + body + '.gif' || 'Could not compute.'
