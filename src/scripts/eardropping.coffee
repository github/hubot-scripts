# Description:
#   Add programmable interface to hubot.  Allow to run a hubot command
#   whenever something came up in the conversation. Optionally, multiple 
#   actions can be specified, with or without ordering.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot when you hear <pattern> do <something hubot does> - Setup a ear dropping event
#   hubot when you hear <pattern> do 1|<something hubot does>; 2|<some.... - Set up ear dropping with multiple actions and ordering
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
  add: (pattern, action, order) ->
    task = {key: pattern, task: action, order: order}
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
    for task_raw in msg.match[2].split ";"
      task_split = task_raw.split "|"
      # If it's a single task, don't add an "order" property
      if not task_split[1]
        earDropping.add(key, task_split[0])
      else
        earDropping.add(key, task_split[1], task_split[0])
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

    tasks = earDropping.all()
    tasks.sort (a,b) ->
      return if a.order >= b.order then 1 else -1

    tasksToRun = []
    for task in tasks
      if new RegExp(task.key, "i").test(robotHeard)
        tasksToRun.push task

    tasksToRun.sort (a,b) ->
      return if a.order >= b.order then 1 else -1

    for task in tasksToRun
      if (robot.name != msg.message.user.name && !(new RegExp("^#{robot.name}", "i").test(robotHeard)))
        robot.receive new TextMessage(msg.message.user, "#{robot.name}: #{task.task}")
