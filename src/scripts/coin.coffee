# Help decide between two things
#
# throw a coin - Gives you heads or tails
#

thecoin = ["heads", "tails"]

module.exports = (robot) ->
  robot.respond /(throw|flip|toss) a coin/i, (msg) ->
    msg.reply msg.random thecoin
