# Description:
#   Add programmable interface to hubot.  Allow to run a hubot command
#   whenever something came up in the conversation.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot when you hear <pattern> do <something hubot does> - Setup a ear dropping event
#   hubot stop ear dropping - Stop all ear dropping
#   hubot stop ear dropping on <pattern> - Remove a particular ear dropping event
#   hubot show ear dropping - Show what hubot is ear dropping on
#
# Author:
#   garylin

TextMessage = require('hubot').TextMessage

class EarDropping
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.eardropping
        @cache = @robot.brain.data.eardropping
  add: (pattern, action) ->
    task = {key: pattern, task: action}
    @cache.push task
    @robot.brain.data.eardropping = @cache
  all: -> @cache
  deleteByPattern: (pattern) ->
    @cache = @cache.filter (n) -> n.key != pattern
    @robot.brain.data.eardropping = @cache
  deleteAll: () ->
    @cache = []
    @robot.brain.data.eardropping = @cache

module.exports = (robot) ->
  earDropping = new EarDropping robot

  robot.respond /when you hear (.+?) do (.+?)$/i, (msg) ->
    key = msg.match[1]
    task = msg.match[2]
    earDropping.add(key, task)
    msg.send "I am now ear dropping for #{key}. Hehe."

  robot.respond /stop ear *dropping$/i, (msg) ->
    earDropping.deleteAll()
    msg.send 'Okay, fine. :( I will keep my ears shut.'

  robot.respond /stop ear *dropping (for|on) (.+?)$/i, (msg) ->
    pattern = msg.match[2]
    earDropping.deleteByPattern(pattern)
    msg.send "Okay, I will ignore #{pattern}"

  robot.respond /show ear *dropping/i, (msg) ->
    response = "\n"
    for task in earDropping.all()
      response += "#{task.key} -> #{task.task}\n"
    msg.send response

  robot.hear /(.+)/i, (msg) ->
    robotHeard = msg.match[1]

    for task in earDropping.all()
      if new RegExp(task.key, "i").test(robotHeard)
        if (robot.name != msg.message.user.name && !(new RegExp("^#{robot.name}", "i").test(robotHeard)))
          robot.receive new TextMessage(msg.message.user, "#{robot.name}: #{task.task}")
