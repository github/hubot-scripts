# Allows Hubot to help you decide between multiple options.
#
# decide "<option1>" "<option2>" "<optionx>" - Randomly picks an option.
#                                        More fun than using a coin.
#
# Examples:
#
# decide "Vodka Tonic" "Tom Collins" "Rum & Coke"
# decide "Stay in bed like a lazy bastard" "You have shit to code, get up!"
#

module.exports = (robot) ->
  robot.respond /decide "(.*)"/i, (msg) ->
    options = msg.match[1].split('" "')
    msg.reply("Definitely \"#{ msg.random options }\".")