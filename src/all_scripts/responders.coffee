# Description:
#   Define new responders on the fly.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot responders - List all responders
#   hubot responder /pattern/ - Show a responder
#   hubot forget /pattern/ - Remove a responder
#   hubot respond /pattern/ msg.send(...) - Create a new responder
#
# Notes:
#   It's possible to crash Hubot with this script. Comparing pathological
#   strings against evil regular expressions will crash Hubot. Callbacks with
#   infinite loops will crash Hubot. So, you know, don't do that. For example,
#   this is bad: "Hubot: respond /(a+)+/ while(1);".
#
# Author:
#   tfausak

class Responders
  constructor: (@robot) ->
    @robot.brain.data.responders = {}
    @robot.brain.on 'loaded', (data) =>
      for pattern, responder of data.responders
        delete responder.index
        @add(pattern, responder.callback)

  responders: ->
    @robot.brain.data.responders

  responder: (pattern) ->
    @responders()[pattern]

  remove: (pattern) ->
    responder = @responder(pattern)
    if responder
      if responder.index
        @robot.listeners.splice(responder.index, 1, (->))
      delete @responders()[pattern]
    responder

  add: (pattern, callback) ->
    try
      eval_pattern = eval("/#{pattern}/i")
    catch error
      eval_pattern = null

    try
      eval_callback = eval("_ = function (msg) { #{callback} }")
    catch error
      eval_callback = null

    if eval_pattern instanceof RegExp and eval_callback instanceof Function
      @remove(pattern)
      @robot.respond(eval_pattern, eval_callback)
      @responders()[pattern] = {
        callback: callback,
        index: @robot.listeners.length - 1,
      }
      @responder(pattern)

module.exports = (robot) ->
  responders = new Responders(robot)

  robot.respond /responders/i, (msg) ->
    patterns = Object.keys(responders.responders()).sort()
    if patterns.length
      response = ''
      for pattern in patterns
        response += "/#{pattern}/ #{responders.responder(pattern).callback}\n"
      msg.send(response.trim())
    else
      msg.send("I'm not responding to anything.")

  robot.respond /responder \/(.+)\//i, (msg) ->
    pattern = msg.match[1]
    responder = responders.responder(pattern)
    if responder
      msg.send(responder.callback)
    else
      msg.send("I'm not responding to /#{pattern}/.")

  robot.respond /forget \/(.+)\//i, (msg) ->
    pattern = msg.match[1]
    responder = responders.remove(pattern)
    if responder
      msg.send("I'll stop responding to /#{pattern}/.")
    else
      msg.send("I wasn't responding to /#{pattern}/ anyway.")

  robot.respond /respond \/(.+)\/ ([^]+)/i, (msg) ->
    pattern = msg.match[1]
    callback = msg.match[2]
    responder = responders.add(pattern, callback)
    if responder
      msg.send("I'll start responding to /#{pattern}/.")
    else
      msg.send("I'd like to respond to /#{pattern}/ but something went wrong.")
