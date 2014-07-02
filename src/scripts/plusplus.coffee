# Description:
#   Give or take away points. Keeps track and even prints out graphs.
#
# Dependencies:
#   "underscore": ">= 1.0.0"
#   "clark": "0.0.6"
#
# Configuration:
#
# Commands:
#   <name>++
#   <name>--
#   hubot score <name>
#   hubot top <amount>
#   hubot bottom <amount>
#
# Author:
#   ajacksified

_ = require("underscore")
clark = require("clark").clark

class ScoreKeeper
  constructor: (@robot) ->
    @cache =
      scoreLog: {}
      scores: {}

    @robot.brain.on 'loaded', =>
      @robot.brain.data.scores ||= {}
      @robot.brain.data.scoreLog ||= {}

      @cache.scores = @robot.brain.data.scores
      @cache.scoreLog = @robot.brain.data.scoreLog

  getUser: (user) ->
    @cache.scores[user] ||= 0
    user

  saveUser: (user, from) ->
    @saveScoreLog(user, from)
    @robot.brain.data.scores[user] = @cache.scores[user]
    @robot.brain.data.scoreLog[from] = @cache.scoreLog[from]
    @robot.brain.emit('save', @robot.brain.data)

    @cache.scores[user]

  add: (user, from) ->
    if @validate(user, from)
      user = @getUser(user)
      @cache.scores[user]++
      @saveUser(user, from)

  subtract: (user, from) ->
    if @validate(user, from)
      user = @getUser(user)
      @cache.scores[user]--
      @saveUser(user, from)

  scoreForUser: (user) -> 
    user = @getUser(user)
    @cache.scores[user]

  saveScoreLog: (user, from) ->
    unless typeof @cache.scoreLog[from] == "object"
      @cache.scoreLog[from] = {}

    @cache.scoreLog[from][user] = new Date()

  isSpam: (user, from) ->
    @cache.scoreLog[from] ||= {}

    if !@cache.scoreLog[from][user]
      return false

    dateSubmitted = @cache.scoreLog[from][user]

    date = new Date(dateSubmitted)
    messageIsSpam = date.setSeconds(date.getSeconds() + 30) > new Date()

    if !messageIsSpam
      delete @cache.scoreLog[from][user] #clean it up

    messageIsSpam

  validate: (user, from) ->
    user != from && user != "" && !@isSpam(user, from)

  length: () ->
    @cache.scoreLog.length

  top: (amount) ->
    tops = []

    for name, score of @cache.scores
      tops.push(name: name, score: score)

    tops.sort((a,b) -> b.score - a.score).slice(0,amount)

  bottom: (amount) ->
    all = @top(@cache.scores.length)
    all.sort((a,b) -> b.score - a.score).reverse().slice(0,amount)

module.exports = (robot) ->
   robot.logger.warning "plusplus.coffee has merged with karma.coffee and moved from hubot-scripts to its own package. Remove it from your hubot-scripts.json and see https://github.com/ajacksified/hubot-plusplus for upgrade instructions"
  scoreKeeper = new ScoreKeeper(robot)

  robot.hear /([\w\S]+)([\W\s]*)?(\+\+)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.add(name, from)

    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.hear /([\w\S]+)([\W\s]*)?(\-\-)$/i, (msg) ->
    name = msg.match[1].trim().toLowerCase()
    from = msg.message.user.name.toLowerCase()

    newScore = scoreKeeper.subtract(name, from)
    if newScore? then msg.send "#{name} has #{newScore} points."

  robot.respond /score (for\s)?(.*)/i, (msg) ->
    name = msg.match[2].trim().toLowerCase()
    score = scoreKeeper.scoreForUser(name)

    msg.send "#{name} has #{score} points."

  robot.respond /(top|bottom) (\d+)/i, (msg) ->
    amount = parseInt(msg.match[2])
    message = []

    tops = scoreKeeper[msg.match[1]](amount)

    for i in [0..tops.length-1]
      message.push("#{i+1}. #{tops[i].name} : #{tops[i].score}")

    if(msg.match[1] == "top")
      graphSize = Math.min(tops.length, Math.min(amount, 20))
      message.splice(0, 0, clark(_.first(_.pluck(tops, "score"), graphSize)))

    msg.send message.join("\n")

