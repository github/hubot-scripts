# disassemble - NO DISASSEMBLE

module.exports = (robot) ->
  robot.hear /disassemble/i, (msg) ->
    msg.send 'NO DISASSEMBLE!'
