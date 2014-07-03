# Description:
#   Detects and notifies of links that have already been posted.
#
# Dependencies:
#   None.
#
# Configuration:
#   None.
#
# Commands:
#   None.
#
# Authors:
#   sharnik

module.exports = (robot) ->

  robot.hear /(https?:\/\/\S*)/i, (msg) ->
    url = msg.match[0]

    if (date = robot.brain.get(url))
      date = new Date(date)
      msg.send "OLD LINK WARNING: it was posted first on #{date.getDay()}.#{date.getMonth()}.#{date.getFullYear()}."
    else
      robot.brain.set url, (new Date).valueOf()