# Extends robot adding conversation features

hubot = require 'robot'

module.exports = (robot) ->
  robot.eatListeners = {}
  
  # Public: Adds a Listener that receives the next message from the user and av
  # further processing of it.
  #
  # user     - The user name.
  # callback - A Function that is called with a Response object. msg.match[1] w
  #            contain the message text without the bot name
  #
  # Returns nothing.
  robot.eatOneResponse = (user, callback) ->
    robot.eatListeners[user.id] = new hubot.TextListener(@, /\s*(.*?)\s*/, callback)
  
  # Change default receive command, addind processing of eatListeners
  robot.origReceive = robot.receive
  robot.receive = (message) ->
    if message.user.id in robot.eatListeners
      lst = robot.eatListeners[message.user.id]
      delete robot.eatListeners[message.user.id]
      lst.call message
      return
    
    robot.origReceive(message)
  
  # Public: Waits for the next message from the current user.
  #
  # callback - Called with the user response
  #
  # Returns nothing.
  hubot.Robot.Response.prototype.waitResponse = (callback) ->
    this.robot.eatOneResponse this.message.user, callback

