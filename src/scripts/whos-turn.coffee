# Description:
#   Who's turn to do something?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot who <does something>? - Returns who does !
#
# Author:
#   KuiKui

module.exports = (robot) ->
  robot.respond /(who|qui) (.+)\?/i, (msg) ->
    users = []
    for own key, user of robot.brain.users
      users.push "#{user.name}" if "#{user.name}" != robot.name
    msg.send (msg.random users).split(" ")[0] + " " + msg.match[2] + "!"
