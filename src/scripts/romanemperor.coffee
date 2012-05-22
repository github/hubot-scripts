# Approve or disapprove of something
#
# <user> disapproves - Disapprove of something
# <user> approves - Approve of something
#
# Developed by One Mighty Roar (http://github.com/onemightyroar)

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
  	
