# Description:
#   Protect Hubot commands from unauthorized use.
#
# Commands:
#   sudo [command]    Execute the protected command.
#
# Configuration:
#
#   How to use sudo with your plugin:
#
#   Sudo = require('./sudo')
#   sudoers = [123, 456, 789, '1'] # hubot-shell's user id is the string '1'
#
#   module.exports = (robot) ->
#     sudo = new Sudo(robot, sudoers)
#
#     sudo.respond /make me a sandwich/i, (msg) ->
#       msg.send "Okay #{msg.message.user.name}, I'm making you a sandwich."

class Sudo

  constructor: (robot, sudoers) ->
    @robot = robot
    @sudoers = sudoers # array of authorized user ids

  respond: (regex, execute) =>
    # create a responder to deny access to commands without sudo
    @robot.respond RegExp("#{regex.source}"), (msg) =>
      @failedCommand msg, execute

    # create a responder for successful sudo commands
    @robot.respond RegExp("sudo #{regex.source}"), (msg) =>
      @authorizeResponse msg, execute

  failedCommand: (msg, execute) =>
    msg['message']['done'] = true
    msg.send 'This is a protected command, please use sudo.'

  authorizeResponse: (msg, execute) =>
    if msg.message.user.id in @sudoers
      msg['message']['done'] = true
      execute msg

module.exports = Sudo

