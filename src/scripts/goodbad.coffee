# Description:
#   Allows good and bad things to be added to Hubot for sprint retrospective
# 
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot good <good thing> - Add something good that happened this sprint
#   hubot bad <bad thing> - Add something bad that happened this sprint
#   hubot goodlist - List all good things that happened
#   hubot badlist - List all bad things that happened
#   hubot gooddel - Delete all good things that happened
#   hubot baddel - Delete all bad things that happened
#
# Author:
#   gabeguz

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
  goodlist: -> @goodcache
  badlist: -> @badcache
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
  gooddel: ->
    @goodcache = []
    @robot.brain.data.good = @goodcache
  baddel: ->
    @badcache = []
    @robot.brain.data.bad = @badcache

module.exports = (robot) ->
  goodbad = new GoodBad robot
  
  robot.respond /(good) (.+?)$/i, (msg) ->
    message = "#{msg.message.user.name}: #{msg.match[2]}"
    good = goodbad.good message
    msg.send "The sprint is thriving!"

  robot.respond /(bad) (.+?)$/i, (msg) ->
    message = "#{msg.message.user.name}: #{msg.match[2]}"
    bad = goodbad.bad message
    msg.send "The sprint is festering..."

  robot.respond /(goodlist)/i, (msg) ->
    if goodbad.goodlist().length > 0
      response = ""
      for good, num in goodbad.goodlist()
        response += "##{good.num} - #{good.good}\n"
      msg.send response
    else 
      msg.send "Nothing good happened."

  robot.respond /(badlist)/i, (msg) ->
    if goodbad.badlist().length > 0
      response = ""
      for bad, num in goodbad.badlist()
        response += "##{bad.num} - #{bad.bad}\n"
      msg.send response
    else 
      msg.send "Nothing bad happened."

  robot.respond /(gooddel)/i, (msg) ->
    goodbad.gooddel()
    msg.send "Good things deleted." 

  robot.respond /(baddel)/i, (msg) ->
    goodbad.baddel()
    msg.send "Bad things deleted." 
