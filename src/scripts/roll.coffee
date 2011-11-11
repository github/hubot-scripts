# Roll a dice!
#
# roll              - Generates a random number between 1 and 100 inclusive
# roll <num>        - Generates a random number between 1 and <num> inclusive
# roll <num>-<num2> - Generates a random number between <num> and <num2> inclusive
#
# Examples
#
#   roll
#   # => rolled a 99 of 100
#   roll 6
#   # => rolled a 5 of 6
#   roll 100-105
#   # => rolled a 104 of 105
#
module.exports = (robot) ->
  robot.respond /(roll)\s?(\d+)?-?(\d+)?/i, (msg) ->
    low  = 1
    high = 100

    if msg.match[3] == undefined && msg.match[2]
      high = parseInt(msg.match[2])
    else if msg.match[2] && msg.match[3]
      low  = parseInt(msg.match[2])
      high = parseInt(msg.match[3])

    rand = Math.floor(Math.random() * (high - low + 1)) + low
    msg.reply "rolled a #{rand} of #{high}"

