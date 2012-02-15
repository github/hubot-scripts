# Allows good and bad things to be added to Hubot for sprint retrospective
#  Based on tasks.coffee
#
# good <good thing> - Add something good that happened this sprint
# bad <bad thing> - Add something bad that happened this sprint
# goodlist - List all good things that happened
# badlist - List all bad things that happened

class GoodBad
  constructor: (@robot) ->
    @goodcache = []
    @badcache = []
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
  delgood: ->
    good = @goodcache = []
    good 
  delbad:
    bad = @badcache = []
    bad

module.exports = (robot) ->
  goodbad = new GoodBad robot
  
  robot.respond /(good) (.+?)$/i, (msg) ->
    good = goodbad.good msg.match[2]
    msg.send "The sprint is thriving!"

  robot.respond /(bad) (.+?)$/i, (msg) ->
    bad = goodbad.bad msg.match[2]
    msg.send "The sprint is festering..."

  robot.respond /(goodlist)/i, (msg) ->
    if goodbad.goodall().length > 0
      response = ""
      for good, num in goodbad.goodall()
        response += "##{good.num} - #{good.good}\n"
      msg.send response
    else 
      msg.send "Nothing good happened."

  robot.respond /(badlist)/i, (msg) ->
    if goodbad.badall().length > 0
      response = ""
      for bad, num in goodbad.badall()
        response += "##{bad.num} - #{bad.bad}\n"
      msg.send response
    else 
      msg.send "Nothing bad happened."

  robot.respond /(delgood)/i, (msg) ->
    goodbad.delgood()
    msg.send "Good things deleted." 

  robot.respond /(delbad)/i, (msg) ->
    goodbad.delbad()
    msg.send "Bad things deleted." 
