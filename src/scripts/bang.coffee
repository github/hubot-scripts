# Description:
#   A hubot interface for Bang, a key-value store for text snippets
#
# Dependencies:
#   "bang": "1.0.1"
#   "shellwords": "0.0.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot bang [--help|--list|--delete] <key> [value] - Store and retrieve text snippets
#
# Author:
#   jimmycuadra

Bang  = require "bang"
{split} = require "shellwords"

module.exports = (robot) ->
  robot.respond /bang\s+(.*)/i, (msg) ->
    try
      args = split(msg.match[1])
    catch error
      return msg.send "I couldn't Bang that cause your quotes didn't match."

    bang = new Bang
    bang.data = robot.brain.data.bang ?= {}
    bang.save = ->

    [key, value] = args

    if key in ["-h", "--help"]
      msg.send  """
                Bang stores text snippets in my brain.
                Set a key:    #{robot.name} bang foo bar
                Get a key:    #{robot.name} bang foo
                Delete a key: #{robot.name} bang [-d|--delete] foo
                List keys:    #{robot.name} bang [-l|--list]
                Get help:     #{robot.name} bang [-h|--help]
                """
    else if key in ["-l", "--list"]
      list = bang.list()
      if list
        msg.send list
      else
        msg.send "I couldn't find any Bang data in my brain."
    else if key in ["-d", "--delete"] and value
      bang.delete value
      msg.send "I stopped Banging #{value}."
    else if key and value
      bang.set key, value
      msg.send "I Banged #{value} into #{key}."
    else if key
      result = bang.get key
      if result
        msg.send result
      else
        msg.send "Nothing's been Banged into #{key}."
