# Description:
#   Informs people of the good work they're doing.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   !m <username> - Tells <username> they're doing good work!
#
# Notes:
#   See http://bangmotivate.appspot.com/ for history.
#
# Author:
#   meatballhat

module.exports = (robot) ->
  robot.hear /!m\s*(.*)?$/i, (msg) ->
    msg.send "You're doing good work, " + msg.match[1] + "!"
