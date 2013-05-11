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
#
# Author:
#   harukizaemon

module.exports = (robot) ->

  robot.hear /surely you/i, (msg) ->
    msg.reply "I am, and don't call me Shirley."

  robot.hear /I can'?t .* tell/i, (msg) ->
    msg.reply "You can tell me. I'm a doctor."

  robot.hear /I('?ve| have) never/i, (msg) ->
    msg.reply "You ever seen a grown man naked?"

  robot.hear /hospital\?/i, (msg) ->
    msg.reply "It's a big building with patients, but that's not important right now."
