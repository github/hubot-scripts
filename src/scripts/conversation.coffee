# Description:
#   Extends robot adding conversation features
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   pescuma

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
    robot.eatListeners[user.id] = new Listener(robot, callback)

  # Change default receive command, addind processing of eatListeners
  robot.origReceive = robot.receive
  robot.receive = (message) ->
    if message.user? and robot.eatListeners[message.user.id]?
      lst = robot.eatListeners[message.user.id]
      delete robot.eatListeners[message.user.id]

      if lst.call message
        return

      # Put back to process next message
      robot.eatListeners[message.user.id] = lst

    robot.origReceive(message)

  # Public: Waits for the next message from the current user.
  #
  # callback - Called with the user response
  #
  # Returns nothing.
  robot.Response.prototype.waitResponse = (callback) ->
    robot.eatOneResponse this.message.user, callback

class Listener
  constructor: (@robot, @callback) ->
    if robot.enableSlash
      @regex = new RegExp("^(?:\/|#{robot.name}:?)\\s*(.*?)\\s*$", 'i')
    else
      @regex = new RegExp("^#{robot.name}:?\\s*(.*?)\\s*$", 'i')

    @matcher = (message) =>
      if message.text?
        message.text.match @regex

  call: (message) =>
    if match = @matcher message
      @callback new @robot.Response(@robot, message, match)
      return true
    else
      return false
