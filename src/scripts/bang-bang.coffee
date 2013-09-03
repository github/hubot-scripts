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
#   hubot !! - Repeat the last command directed at hubot
#
# Author:
#   None

module.exports = (robot) ->
  robot.respond /(.+)/i, (msg) ->
    store msg

  robot.respond /!!$/i, (msg) ->

    if exports.last_command?
      msg.send exports.last_command
      msg['message']['text'] = "#{robot.name}: #{exports.last_command}"
      robot.receive(msg['message'])
      msg['message']['done'] = true
    else
      msg.send "i don't remember hearing anything."

store = (msg) ->
  command = msg.match[1].trim()
  exports.last_command = command unless command == '!!'
