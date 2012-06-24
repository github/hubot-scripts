# Description:
#   Approve or disapprove of something
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot <user> disapproves - Disapprove of something
#   hubot <user> approves - Approve of something
#
# Author:
#   eliperkins

module.exports = (robot) ->
  robot.respond /@?([\w .-_]+) disapproves/i, (msg) ->
    name = msg.match[1]	
    user = msg.message.user
    firstname = user.name.toLowerCase().split(" ")[0]
    if (firstname is name)
      msg.send "http://i3.kym-cdn.com/photos/images/newsfeed/000/254/517/a70.gif"
    else
      msg.send firstname + ", stop pretending to be " + name
      
      
  robot.respond /@?([\w .-_]+) approves/i, (msg) ->
    name = msg.match[1]	
    user = msg.message.user
    firstname = user.name.toLowerCase().split(" ")[0]
    if (firstname is name)
      msg.send "http://i1.kym-cdn.com/photos/images/newsfeed/000/254/655/849.gif"
    else
      msg.send firstname + ", stop pretending to be " + name
