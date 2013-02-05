# Description:
#   Notifies you by Prowl or NotifyMyAndroid when you're mentioned
#
# Dependencies:
#   "prowler": "0.0.3"
#
# Configuration:
#   None
#
# Commands:
#   hubot notify me by prowl with YOUR_PROWL_API_KEY
#   hubot notify me by nma with YOUR_NMA_API_KEY
#   hubot notify me by sms with 15556667890
#   hubot list notifiers
#
# Author:
#   marten
#
https = require "https"
Prowl = require "prowler"
QS = require "querystring"

module.exports = (robot) ->
  sendSms = (to, msg) ->
    sid   = process.env.HUBOT_SMS_SID
    tkn   = process.env.HUBOT_SMS_TOKEN
    from  = process.env.HUBOT_SMS_FROM
    auth  = 'Basic ' + new Buffer(sid + ':' + tkn).toString("base64")
    data  = QS.stringify
      From: from
      To: to
      Body: "#{msg.message.user.name}: #{msg.message.text}"
    unless sid
      msg.send "Twilio SID isn't set."
      msg.send "Please set the HUBOT_SMS_SID environment variable."
      return

    unless tkn
      msg.send "Twilio token isn't set."
      msg.send "Please set the HUBOT_SMS_TOKEN environment variable."
      return

    unless from
      msg.send "Twilio from number isn't set."
      msg.send "Please set the HUBOT_SMS_FROM environment variable."
      return

    msg.http("https://api.twilio.com")
      .path("/2010-04-01/Accounts/#{sid}/SMS/Messages.json")
      .header("Authorization", auth)
      .header("Content-Type", "application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        json = JSON.parse body
        switch res.statusCode
          when 201
            msg.send "Sent sms to #{to}"
          when 400
            msg.send "Failed to send. #{json.message}"
          else
            msg.send "Failed to send."
    


  notify = (username, msg) ->
    notifies = []
    console.error "Going notify #{username}"
    if username == "all" or username == "everyone"
      for username, apikey of robot.brain.data.notifiers
        unless username.toLowerCase() == msg.message.user.name.toLowerCase()
          notifies.push apikey
    else if apikey = robot.brain.data.notifiers[username.toLowerCase()]
      notifies.push apikey

    for notifier in notifies
      [protocol, apikey...] = notifier.split(':')
      apikey = apikey.join('')
      msg.send("Notified #{protocol} by #{apikey}")

      switch protocol
        when "prowl"
          notification = new Prowl.connection(apikey)
          notification.send
            application: 'RoQua Hubot'
            event: 'Mention'
            description: msg.message.text
        when "sms"
          console.error "Sending sms"
          sendSms apikey, msg
        
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

  checkIfOffline = (user, callback) ->
    if process.env.HUBOT_HIPCHAT_TOKEN
      options =
        host: "api.hipchat.com"
        port: 443
        path: "/v1/users/show?"+QS.stringify({
          format:"json"
          user_id:user.id
          auth_token:process.env.HUBOT_HIPCHAT_TOKEN
        })
        method: "GET"

      req = https.request options, (res) ->
        res.on "data", (data) ->
          userData = JSON.parse(data.toString())
          callback null, userData.user.status=="offline"
        res.on "error", (err) ->
          callback err
      req.end()
    else
      callback null, true

  robot.hear /@(\w+)/i, (msg) ->
    sender   = msg.message.user.name.toLowerCase()
    mentionedUserName = msg.match[1].toLowerCase()
    if mentionedUserName == "all" or mentionedUserName == "everyone"
      notify "all", msg
      msg.send "All notified!"
      return
      
    
    for userId, user of robot.brain.users
      if user.mention_name==mentionedUserName
        username=user.name
        mentionedUserId = userId
        theUser = user
    if not mentionedUserId?
      return
    checkIfOffline theUser, (err, offline) ->
      if err
        throw err
      else if offline
        notify username, msg
 
    
  robot.respond /do not notify me/i, (msg) ->
    delete robot.brain.data.notifiers[msg.message.user.name.toLowerCase()]
    msg.send "OK"


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

  robot.respond /notify me by sms with (\d+)/i, (msg) ->
    number = msg.match[1].toLowerCase()
    robot.brain.data.notifiers ?= {}
    robot.brain.data.notifiers[msg.message.user.name.toLowerCase()] = "sms:#{number}"
    msg.send "OK"


  robot.respond /list notifiers/i, (msg) ->
    for username, apikey of robot.brain.data.notifiers
      msg.send("I notify #{username} with #{apikey}")
