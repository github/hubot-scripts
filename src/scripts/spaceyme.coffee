# Description:
#   Random sized picture of Kevin Spacey on demand
#
# Commands
#   spacey me

sizes  = [100...500]

module.exports = (robot) ->
  robot.respond /spacey me/i, (msg) ->
    height = msg.random sizes
    width  = msg.random sizes
    msg.send "http://kevinspacer.com/#{width}/#{height}#.png"
