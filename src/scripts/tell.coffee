# THIS SCRIPT HAS MOVED TO ITS OWN PACKAGE. PLEASE USE
# https://github.com/hubot-scripts/hubot-tell INSTEAD!
#
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
   robot.logger.warning "tell.coffee has moved from hubot-scripts to its own package. See https://github.com/hubot-scripts/hubot-tell/blob/master/UPGRADING.md for upgrade instructions"
   localstorage = {}
   robot.respond /tell ([\w.-]*):? (.*)/i, (msg) ->
     datetime = new Date()
     username = msg.match[1]
     room = msg.message.user.room
     tellmessage = msg.message.user.name + " @ " + datetime.toLocaleString() + " said: " + msg.match[2] + "\r\n"
     if not localstorage[room]?
       localstorage[room] = {}
     if localstorage[room][username]?
       localstorage[room][username] += tellmessage
     else
       localstorage[room][username] = tellmessage
     msg.send "Ok, I'll tell #{username} you said '#{msg.match[2]}'."
     return
 
   # When a user enters, check if someone left them a message
   robot.enter (msg) ->
     username = msg.message.user.name
     room = msg.message.user.room
     if localstorage[room]?
       for recipient, message of localstorage[room]
         # Check if the recipient matches username
         if username.match(new RegExp "^"+recipient, "i")
           tellmessage = username + ": " + localstorage[room][recipient]
           delete localstorage[room][recipient]
           msg.send tellmessage
     return
