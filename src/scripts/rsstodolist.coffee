# Description:
#   Allows you to send links to the RssToDoList service
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rtdl show <user_name> - Display the <user_name> RssToDoList feed url
#   hubot rtdl add <user_name> <link> - Send the <link> to <user_name> RssToDoList feed
#
# Author:
#   athieriot

module.exports = (robot) ->
  robot.respond /rtdl (add|show) ([^ ]*)( .*)?/i, (msg) ->
   server_url = 'http://rsstodolist.appspot.com'

   [action, user_name, link] = [msg.match[1], escape(msg.match[2]), msg.match[3]]

   if action == 'add' && link != undefined
      msg.http(server_url + '/add')
         .query(n: user_name)
         .query(url: link.trim())
         .get() (err, res, body) ->
            status = res.statusCode 

            if status == 200 || status == 302
               msg.reply 'The feed of ' + user_name  + ' is updated'
            else
               msg.reply "An error occured on " + user_name + " feed" 
   else if action == 'show'
      msg.reply user_name + ' feed is ' + server_url + '/?n=' + user_name
