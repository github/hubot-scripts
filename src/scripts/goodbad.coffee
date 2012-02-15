# Allows tasks (TODOs) to be added to Hubot
#
# task add <task> - Add a task
# task list tasks - List the tasks
# task delete <task number> - Delete a task
#

class GoodBad
  constructor: (@robot) ->
    @goodcache = []
    @badcache = []
    #@cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.good
        @goodcache = @robot.brain.data.good
      if @robot.brain.data.bad
        @badcache = @robot.brain.data.bad

  nextGoodNum: ->
    maxGoodNum = if @goodcache.length then Math.max.apply(Math,@goodcache.map (n) -> n.num) else 0
    maxGoodNum++
    maxGoodNum
  nextBadNum: ->
    maxBadNum = if @badcache.length then Math.max.apply(Math,@badcache.map (n) -> n.num) else 0
    maxBadNum++
    maxBadNum  
  add: (taskString) ->
    task = {num: @nextTaskNum(), task: taskString}
    @cache.push task
    @robot.brain.data.tasks = @cache
    task
  goodall: -> @goodcache
  badall: -> @badcache
  good: (goodString) ->
    goodthing = {num: @nextGoodNum(), good: goodString}
    @goodcache.push goodthing
    @robot.brain.data.good = @goodcache
    goodthing
  bad: (badString) ->
    badthing = {num: @nextBadNum(), bad: badString}
    @badcache.push badthing
    @robot.brain.data.bad = @badcache
    badthing
  deleteByNumber: (num) ->
    index = @cache.map((n) -> n.num).indexOf(parseInt(num))
    task = @cache.splice(index, 1)[0]
    @robot.brain.data.tasks = @cache
    task

module.exports = (robot) ->
  #tasks = new Tasks robot
  goodbad = new GoodBad robot
  
  robot.respond /(good:) (.+?)$/i, (msg) ->
    good = goodbad.good msg.match[2]
    msg.send "The sprint is thriving!"

  robot.respond /(bad:) (.+?)$/i, (msg) ->
    bad = goodbad.bad msg.match[2]
    msg.send "The sprint is festering..."

#  robot.respond /(task add|add task) (.+?)$/i, (msg) ->
#    task = tasks.add msg.match[2]
#    msg.send "Task added: ##{task.num} - #{task.task}"

  robot.respond /(good list)/i, (msg) ->
    if goodbad.goodall().length > 0
      response = ""
      for good, num in goodbad.goodall()
        response += "##{good.num} - #{good.good}\n"
      msg.send response
    else 
      msg.send "Nothing good happened."

#  robot.respond /(task list|list tasks)/i, (msg) ->
#    if tasks.all().length > 0
#      response = ""
#      for task, num in tasks.all()
#        response += "##{task.num} - #{task.task}\n"
#      msg.send response
#    else
#      msg.send "There are no tasks"

  robot.respond /(task delete|delete task) #?(\d+)/i, (msg) ->
    taskNum = msg.match[2]
    task = tasks.deleteByNumber taskNum
    msg.send "Task deleted: ##{task.num} - #{task.task}"
