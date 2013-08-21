# Description:
#   Class name generator. Inspired by classnamer.com
#
# Commands:
#   hubot class me - generates a class name
#
# Author:
#   ianmurrays
#
# Dependencies:
#   classnamer gem – Install with `gem install classnamer`

child_process = require 'child_process'

module.exports = (robot) ->
  robot.respond /class(?: me)?/i, (msg) -> 
    child_process.exec 'classnamer', (error, stdout, stderr) ->
      if error
        msg.send "Sorry, but the classnamer gem is not installed. Install with `gem install classnamer`."
      else
        msg.send stdout.trim()
