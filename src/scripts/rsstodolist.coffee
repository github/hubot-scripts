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
#   hubot rtdl last <user_name> <limit> - Display last links for that <user_name> (you can specify an optional <limit>)
#
# Author:
#   athieriot
#   paulgreg

jsdom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /rtdl (add|show|last) ([^ ]*)( .*)?/i, (msg) ->
   server_url = 'http://rsstodolist.appspot.com'

   [action, user_name, arg] = [msg.match[1], escape(msg.match[2]), msg.match[3]]

   if action == 'add' && arg != undefined
      msg.http(server_url + '/add')
         .query(n: user_name)
         .query(url: arg.trim())
         .get() (err, res, body) ->
            status = res.statusCode 

            if status == 200 || status == 302
               msg.reply 'The feed of ' + user_name  + ' is updated'
            else
               msg.reply "An error occured on " + user_name + " feed" 
   else if action == 'show'
      msg.reply user_name + ' feed is ' + server_url + '/?n=' + user_name
   else if action == 'last'
      msg.http(server_url + '/')
         .query(n: user_name)
         .query(l: arg || 10)
         .get() (err, res, body) ->
            try
              reply = ''
              xml = jsdom.jsdom(body)
              for item in xml.getElementsByTagName("rss")[0].getElementsByTagName("channel")[0].getElementsByTagName("item")
                do (item) ->
                  link = item.getElementsByTagName("link")[0].childNodes[0].nodeValue
                  title = item.getElementsByTagName("title")[0].childNodes[0].nodeValue
                  descriptionNode = item.getElementsByTagName("description")[0]
                  description = descriptionNode.childNodes[0].nodeValue if descriptionNode.childNodes.length == 1

                  reply += " - #{title},"
                  reply += " #{description}" if description?
                  reply += " (#{link})\n"
            catch err
                  msg.reply err

            msg.reply reply

