# Description:
#   Get pnd monsters information by number
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pnd <number>
#
# Author:
#   Arthraim

module.exports = (robot) ->
  robot.respond /p[na]d( me)? (.*)/i, (msg) ->
    msg.send "[MONSTER INFO] http://www.puzzledragonx.com/en/monster.asp?n=#{ msg.match[2] }"
    msg.send "http://www.puzzledragonx.com/en/img/monster/MONS_#{ msg.match[2] }.jpg"
