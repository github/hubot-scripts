# Notifies you by Prowl or NotifyMyAndroid when you're mentioned
#
# To setup your username for notification:
#
#   hubot notify me by prowl with YOUR_PROWL_API_KEY
#   hubot notify me by nma with YOUR_NMA_API_KEY
#   hubot list notifiers
#
# Then when this happens in the chat, you'll be notified (assuming
# your name is jim):
#
#   Hey @jim, how's it going.
#   Congrats @everyone on this cool new thing we deployed.
#
# TODO Hear multiple highlights?
# TODO Hear highlights without @

Prowl = require "prowler"
QS = require "querystring"

module.exports = (robot) ->
  robot.hear /@(\w+)/i, (msg) ->
    sender   = msg.message.user.name.toLowerCase()
    username = msg.match[1].toLowerCase()
    notifies = []

    if username == "all" or username == "everyone"
      for username, apikey of robot.brain.data.notifiers
        unless username == sender
          notifies.push apikey
    else if apikey = robot.brain.data.notifiers[username]
      notifies.push apikey

    for notifier in notifies
      [protocol, apikey...] = notifier.split(':')
      apikey = apikey.join('')
      #msg.send("Notified #{protocol} by #{apikey}")

      switch protocol
        when "prowl"
          notification = new Prowl.connection(apikey)
          notification.send
            application: 'RoQua Hubot'
            event: 'Mention'
            description: msg.message.text
        when "nma"
          params = 
            apikey: apikey
            application: "Hubot"
            event: "Mention"
            description: msg.message.text
          msg.http("https://www.notifymyandroid.com/publicapi/notify")
            .query(params)
            .get() (err, res, body) ->
              body


  robot.respond /notify me by prowl with (\w+)/i, (msg) ->
    apikey = msg.match[1].toLowerCase()
    robot.brain.data.notifiers ?= {}
    robot.brain.data.notifiers[msg.message.user.name.toLowerCase()] = "prowl:#{apikey}"
    msg.send "OK"

  robot.respond /notify me by nma with (\w+)/i, (msg) ->
    apikey = msg.match[1].toLowerCase()
    robot.brain.data.notifiers ?= {}
    robot.brain.data.notifiers[msg.message.user.name.toLowerCase()] = "nma:#{apikey}"
    msg.send "OK"

  robot.respond /list notifiers/i, (msg) ->
    for username, apikey of robot.brain.data.notifiers
      msg.send("I notify #{username} with #{apikey}")