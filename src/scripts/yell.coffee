# Description
#   Allows you to "yell" your message to everyone in the room
#
# Dependencies:
#   "underscore": "1.3.3"
#
# Configuration:
#   None
#
# Commands:
#   hubot yell <message> - Sends your message and mentions everyone curently in the chat room.
#
# Notes:
#   Nobody likes when you yell all the time :(
#
# Author:
#   MattSJohnston

module.exports = (robot) ->

  _ = require 'underscore'

  robot.respond /yell (.*)/i, (msg) ->
    users = _.reject((_.values _.pluck robot.brain.data.users, 'name'), (name) -> name == msg.message.user.name)
    msg.send if users.length then users.join(', ') + ": #{msg.match[1]}" else "If a tree falls in a forest and no one is around to hear it, does it make a sound?"


toTitleCase = (str) ->
  str.replace /\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
