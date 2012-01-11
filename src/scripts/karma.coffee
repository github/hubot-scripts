# Track arbitrary karma
#
# <thing>++ - give thing some karma
# <thing>-- - take away some of thing's karma
# karma <thing> - check thing's karma, if <thing> is ommitted get top and bottom 3
class Karma
  
  constructor: (@robot) ->
    @cache = {}
    
    @increment_responses = [
      "+1!", "gained a level!", "is on the rise!", "leveled up!"
    ]
  
    @decrement_responses = [
      "took a hit! Ouch.", "took a dive.", "lost a life.", "lost a level."
    ]
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.karma
        @cache = @robot.brain.data.karma

  increment: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] += 1
    @robot.brain.data.karma = @cache

  decrement: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] -= 1
    @robot.brain.data.karma = @cache
  
  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]
  
  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

  summary: ->
    s = []
    for key,val of @cache
      s.push({name: key, karma: val})
    s.sort (a,b) -> b.karma - a.karma
    if s.length >= 6
      return [s[0], s[1], s[2], s[s.length-3], s[s.length-2], s[s.length-1]]
    else
      return s

module.exports = (robot) ->
  karma = new Karma robot
  robot.hear /(\S+[^+\s])\+\+(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    karma.increment subject
    msg.send "#{subject} #{karma.incrementResponse()} (Karma: #{karma.get(subject)})"
  
  robot.hear /(\S+[^-\s])--(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    karma.decrement subject
    msg.send "#{subject} #{karma.decrementResponse()} (Karma: #{karma.get(subject)})"
  
  robot.respond /karma ?(\S+[^-\s])?$/i, (msg) ->
    if msg.match[1]
      match = msg.match[1].toLowerCase()
      msg.send "\"#{match}\" has #{karma.get(match)} karma."
    else
      s = karma.summary()
      if s.length >= 3
        msg.send "Highest karma: \"#{s[0].name}\" (#{s[0].karma}), " +
               "\"#{s[1].name}\" (#{s[1].karma}), and \"#{s[2].name}\" " +
               "(#{s[2].karma}). Lowest karma: \"#{s[s.length-1].name}\" " +
               "(#{s[s.length-1].karma}), \"#{s[s.length-2].name}\" " +
               "(#{s[s.length-2].karma}), and \"#{s[s.length-3].name}\" " +
               "(#{s[s.length-3].karma})."
      else
        msg.send "There aren't enough items with karma to give a top and bottom 3"