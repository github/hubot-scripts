# disassemble - NO DISASSEMBLE

module.exports = (robot) ->
  robot.respond /disassemble/i, (msg) ->
    msg.send 'NO DISASSEMBLE!'
