# Description:
#   Allows tasks (TODOs) to be added to Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot task add <task> - Add a task
#   hubot task list tasks - List the tasks
#   hubot task delete <task number> - Delete a task
#
# Author:
#   Crofty

class Tasks
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.tasks
        @cache = @robot.brain.data.tasks
  nextTaskNum: ->
    maxTaskNum = if @cache.length then Math.max.apply(Math,@cache.map (n) -> n.num) else 0
    maxTaskNum++
    maxTaskNum
  add: (taskString) ->
    task = {num: @nextTaskNum(), task: taskString}
    @cache.push task
    @robot.brain.data.tasks = @cache
    task
  all: -> @cache
  deleteByNumber: (num) ->
    index = @cache.map((n) -> n.num).indexOf(parseInt(num))
    task = @cache.splice(index, 1)[0]
    @robot.brain.data.tasks = @cache
    task

module.exports = (robot) ->
  tasks = new Tasks robot

  robot.respond /(task add|add task) (.+?)$/i, (msg) ->
    task = tasks.add msg.match[2]
    msg.send "Task added: ##{task.num} - #{task.task}"

  robot.respond /(task list|list tasks)/i, (msg) ->
    if tasks.all().length > 0
      response = ""
      for task, num in tasks.all()
        response += "##{task.num} - #{task.task}\n"
      msg.send response
    else
      msg.send "There are no tasks"

  robot.respond /(task delete|delete task) #?(\d+)/i, (msg) ->
    taskNum = msg.match[2]
    task = tasks.deleteByNumber taskNum
    msg.send "Task deleted: ##{task.num} - #{task.task}"
