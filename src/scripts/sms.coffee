# Allows Hubot to send text messages using Twilio API.
#
# sms <to> <message> - Sends <message> to the number <to>.

QS = require "querystring"

module.exports = (robot) ->
  robot.respond /sms (\d+) (.*)/i, (msg) ->
    to    = msg.match[1]
    bahdy = msg.match[2] # bahdy, that's how john mayer would say it.
    sid   = process.env.HUBOT_SMS_SID
    tkn   = process.env.HUBOT_SMS_TOKEN
    from  = process.env.HUBOT_SMS_FROM
    auth  = 'Basic ' + new Buffer(sid + ':' + tkn).toString("base64")
    data  = QS.stringify From: from, To: to, Body: bahdy

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
