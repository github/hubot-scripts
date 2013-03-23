# Description:
#   Tell Hubot to send a user a message when present in the room
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot tell <username> <some message> - tell <username> <some message> next time they are present. Case-Insensitive prefix matching is employed when matching usernames, so "foo" also matches "Foo" and "foooo"
#
# Author:
#   christianchristensen, lorenzhs, xhochy
 
module.exports = (robot) ->
   localstorage = {}
   robot.respond /tell ([\w.-]*):? (.*)/i, (msg) ->
     datetime = new Date()
     username = msg.match[1].toLowerCase()
     room = msg.message.user.room
     tellmessage = username + ": " + msg.message.user.name + " @ " + datetime.toLocaleString() + " said: " + msg.match[2] + "\r\n"
     if not localstorage[room]?
       localstorage[room] = {}
     if localstorage[room][username]?
       localstorage[room][username] += tellmessage
     else
       localstorage[room][username] = tellmessage
     return
 
   robot.enter (msg) ->
     # just send the messages if they are available...
     username = msg.message.user.name.toLowerCase()
     room = msg.message.user.room
     if localstorage[room]?
       for recipient, message of localstorage[room]
         if username.match(new RegExp "^"+recipient, "i")
           tellmessage = localstorage[room][recipient]
           delete localstorage[room][recipient]
           msg.send tellmessage
     return
