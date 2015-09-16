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
  robot.hear /disassemble/i,{id: 'disassemble.send'}, (msg) ->
    msg.send 'NO DISASSEMBLE!'
