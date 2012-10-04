# Description:
#   Tell Hubot to send a user a message right now !
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot tellnow <username> <some message> - tell <username> <some message> right now !
#
# Author:
#   earlonrails & ggongaware
#
# Additional Requirements
#   Only works on gtalk

module.exports = (robot) ->
  robot.respond /tell ([\w.-@]*) (.*)/i, (msg) ->
   new_user =
    id: msg.match[1] + "@" + msg.message.user.domain
    name: msg.match[1]
    user: msg.match[1]
    type: "chat"

   robot.send new_user, msg.match[2]
