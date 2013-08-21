# Description
#   System utilities for Hubot
#
# Commands:
#   hubot shell <command> - execute a shell command
#
# Notes:
#   This is a dangerous script, it exposes a security hole.
#   Use at your own risk.
#
# Author:
#   spajus

child_process = require 'child_process'

module.exports = (robot) ->

  robot.respond /shell (.+)/i, (msg) ->
    child_process.exec msg.match[1], (error, stdout, stderr) ->
      if error
        msg.send "Error: #{stderr.trim()}"
      else
        msg.send stdout.trim()
