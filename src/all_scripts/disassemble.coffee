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
#   disassemble - NO DISASSEMBLE
#
# Author:
#   listrophy

module.exports = (robot) ->
  robot.hear /disassemble/i, (msg) ->
    msg.send 'NO DISASSEMBLE!'
