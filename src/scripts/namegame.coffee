# Description:
#   Plays the name game.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot name game <name> -- Play the 1964 "Name Game" with submitted name.
#
# Notes:
#   Be warned: If you supply names like Buck, you will get profanity.
#
# Author:
#  jeveleth

module.exports = (robot) ->
    robot.respond /name game (\w+.)/i, (msg) ->
        first_name = msg.match[1]
        new_name = if first_name[0].match(/[^aeiou]/i) then first_name[1..-1] else first_name.toLowerCase()
        val_b = if first_name[0].match(/b/i) then val_b = "" else "B"
        val_f = if first_name[0].match(/f/i) then val_f = "" else "F"
        val_m = if first_name[0].match(/m/i) then val_m = "" else "M"
        msg.reply "#{first_name}, #{first_name}, Bo #{val_b}#{new_name}\nBanana Fana Fo #{val_f}#{new_name}\nFee Fi Mo #{val_m}#{new_name}\n#{first_name}!"
