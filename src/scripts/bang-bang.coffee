# Description:
#   Repeat last command a user sent to hubot
#
# Commands:
#   hubot !! - repeat my last hubot command
#
# URLS:
#   /hubot/server
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

TextMessage = require('hubot').TextMessage

module.exports = (robot) ->

  # Remember last command
  robot.listenerMiddleware (context, next, done) ->
    user = context.response.message.user.name
    cmd =  context.response.message.text
    if cmd != '!!'
      robot.brain.set "#{user}.lastcommand", cmd
    next()

  # Repeat last command if !! is sent
  robot.hear /!!$/i, (msg) ->
    user = msg.envelope.user.name
    cmd = robot.brain.get( "#{user}.lastcommand" )
    if cmd?
      robot.receive new TextMessage user, "#{cmd}"
    else
      msg.send " No previous command remembered for #{user}"
