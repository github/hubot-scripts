# Forces hubot to do what you want, even if he doesn't know how
#
# hubot sudo <anything you want> - Force hubot to do what you want
module.exports = (robot) ->
  robot.respond /(sudo)(.*)/i, (msg) ->
    msg.send "Alright. I'll #{msg.match?[2] || "do whatever it is you wanted."}"

