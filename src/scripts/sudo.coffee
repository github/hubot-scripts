# Description:
#   Forces hubot to do what you want, even if he doesn't know how
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot sudo <anything you want> - Force hubot to do what you want
#
# Author:
#   searls

module.exports = (robot) ->
  robot.respond /(?:sudo) ?(.*)/i, (msg) ->
    msg.send "Alright. I'll #{msg.match?[1] || "do whatever it is you wanted."}"
