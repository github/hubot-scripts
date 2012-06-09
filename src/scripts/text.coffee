# Description:
#   Allows Hubot to send text messages using SMSified API.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SMSIFIED_USERNAME
#   HUBOT_SMSIFIED_PASSWORD
#   HUBOT_SMSIFIED_SENDERADDRESS
#
# Commands:
#   hubot text <phonenumber> <message> - Sends <message> to <phonenumber>.
#
# Notes: 
#   test curl: curl -v "https://username:password@api.smsified.com/v1/smsmessaging/outbound/{senderAddress}/requests" -X POST  -d "address={phonenumber}&message={hello%0Aworld}"
#
# Author:
#   chrismatthieu

QS = require "querystring"

module.exports = (robot) ->
  robot.respond /text (\d+) (.*)/i, (msg) ->
    address = msg.match[1]
    message = msg.match[2] 
    username = process.env.HUBOT_SMSIFIED_USERNAME
    password = process.env.HUBOT_SMSIFIED_PASSWORD
    senderAddress  = process.env.HUBOT_SMSIFIED_SENDERADDRESS
    auth  = 'Basic ' + new Buffer(username + ':' + password).toString("base64")
    data  = QS.stringify address: address, message: message

    unless username
      msg.send "SMSified username isn't set."
      msg.send "Please set the HUBOT_SMSIFIED_USERNAME environment variable."
      return

    unless password
      msg.send "SMSified password isn't set."
      msg.send "Please set the HUBOT_SMSIFIED_PASSWORD environment variable."
      return

    unless senderAddress
      msg.send "SMSified senderAddress isn't set."
      msg.send "Please set the HUBOT_SMSIFIED_SENDERADDRESS environment variable."
      return

    msg.http("https://api.smsified.com")
      .path("/v1/smsmessaging/outbound/#{senderAddress}/requests")
      .header("Authorization", auth)
      .header("Content-Type", "application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        json = JSON.parse body
        switch res.statusCode
          when 201
            msg.send "Sent text message to #{address}"
          when 400
            msg.send "Failed to send text message. #{json.message}"
          else
            msg.send "Failed to send text message."
