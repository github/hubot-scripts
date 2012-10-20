# Description:
#   Protect Hubot commands from unauthorized use.
#
# Commands:
#   sudo [command]    Execute the protected command.
#
# Configuration:
#   Using sudo with your plugin:
#
#   Sudo = require('./sudo')
#   sudoers = [123456, 456789, 101010, 77777] # user ids
#
#   module.exports = (robot) ->
#     sudo = new Sudo(robot, sudoers)
#
#     sudo.respond /make me a sandwich/i, (msg) ->
#       msg.send "Okay #{msg.message.user.name}, I'm making you a sandwich."
#
# Author:
#   Gino Lucero

class Sudo

  constructor: (robot, sudoers) ->
    @robot = robot
    @sudoers = sudoers # array of authorized user ids

  respond: (regex, execute) =>
    # create a responder to deny access to commands without sudo
    @robot.respond RegExp("#{regex.source}"), (msg) =>
      @rejectCommand msg, execute

    # create a responder for successful sudo commands
    @robot.respond RegExp("sudo #{regex.source}"), (msg) =>
      @authorizeSudoCommand msg, execute

  rejectCommand: (msg, execute) =>
    msg['message']['done'] = true
    msg.send 'This is a protected command, please use sudo.'

  authorizeSudoCommand: (msg, execute) =>
    if msg.message.user.id in @sudoers
      msg['message']['done'] = true
      execute msg
    else
      msg.send 'You do not have permission to execute that command.'

module.exports = Sudo

