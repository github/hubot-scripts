# Description:
#   Allows Hubot to help you decide between multiple options
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot decide "<option1>" "<option2>" "<optionx>" - Randomly picks an option
#
# Author:
#   logikal

module.exports = (robot) ->
  robot.respond /decide "(.*)"/i, (msg) ->
    options = msg.match[1].split('" "')
    msg.reply("Definitely \"#{ msg.random options }\".")
