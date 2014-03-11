# Description:
#   wunderlist allows you to add todos to your wunderlist directly from hubot
#
# Dependencies:
#   "mailer": "0.6.7"
#
# Configuration:
#   HUBOT_WUNDERLIST_SMTP_HOST - your smtp host e.g. smtp.gmail.com
#   HUBOT_WUNDERLIST_SMTP_PORT - the port to connect to
#   HUBOT_WUNDERLIST_SMTP_USESSL - whether you want to connect via SSL
#   HUBOT_WUNDERLIST_SMTP_SENDDOMAIN - the domain from which to send
#   HUBOT_WUNDERLIST_SMTP_USEAUTH - BOOL: authentication required
#   HUBOT_WUNDERLIST_SMTP_AUTH_NAME - username for authentication
#   HUBOT_WUNDERLIST_SMTP_AUTH_PASSWORD  - password for authentication
#
# Commands:
#   hubot wunderlist all the users       - display all users which have registered
#   hubot wunderlist add me with <email> - add <email> as wunderlist login
#   hubot wunderlist my login            - display your wunderlist email
#   hubot wunderlist forget me           - remove the wunderlist login
#   hubot wunderlist me <a todo>         - adds the todo to your wunderlist Inbox
#
# Notes:
#   Currently all todos are added to the Inbox.
#
# Author:
#   mrtazz

mail = require 'mailer'

module.exports = (robot) ->

  robot.respond /wunderlist all the users/i, (msg) ->
    theReply = "Here is who I know:\n"

    for own key, user of robot.brain.users
      if(user.wunderlistmail)
        theReply += user.name + " is " + user.wunderlistmail + "\n"

    msg.send theReply

  robot.respond /wunderlist add me with ([\w\d-_.]+@[\w\d-_.]+)/i, (msg) ->
    wunderlistmail = msg.match[1]
    msg.message.user.wunderlistmail = wunderlistmail
    msg.send "Ok, you are " + wunderlistmail + " on Wunderlist"

  robot.respond /wunderlist my login/i, (msg) ->
    user = msg.message.user
    if user.wunderlistmail
      msg.reply "You are known as " + user.wunderlistmail  + " on Wunderlist"
    else
      text = "I don't know who you are. You should probably identify yourself"
      text += "with your Wunderlist login"
      msg.reply text

  robot.respond /wunderlist forget me/i, (msg) ->
    user = msg.message.user
    user.wunderlistmail  = null

    msg.reply("Ok, I have no idea who you are anymore.")

  robot.respond /wunderlist me (.*)/i, (msg) ->
    todo = msg.match[1]
    wunderlistmail = msg.message.user.wunderlistmail
    # change list here
    subject = "Inbox"

    # option settings
    options = {
      host           : process.env.HUBOT_WUNDERLIST_SMTP_HOST                      ,
      port           : process.env.HUBOT_WUNDERLIST_SMTP_PORT        or 25         ,
      ssl            : process.env.HUBOT_WUNDERLIST_SMTP_USESSL      or true       ,
      domain         : process.env.HUBOT_WUNDERLIST_SMTP_SENDDOMAIN  or 'localhost',
      authentication : process.env.HUBOT_WUNDERLIST_SMTP_USEAUTH     or false      ,
      username       : process.env.HUBOT_WUNDERLIST_SMTP_AUTH_NAME                 ,
      password       : process.env.HUBOT_WUNDERLIST_SMTP_AUTH_PASSWORD
    }

    if (options.host)


      options.authentication = if options.authentication is true then 'login' else 'none'
      options.to = 'me@wunderlist.com'
      options.from = wunderlistmail
      options.subject = subject
      options.body = todo

      mail.send options, (err, result) ->
                            console.log(err)
                            if (err)
                              msg.reply "I'm sorry, I couldn't add your todo."
                            else
                              msg.reply "Your todo was added."

