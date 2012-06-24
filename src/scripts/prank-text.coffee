# Description:
#   Prank text a friend (or enemy)
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   SMS_USERNAME
#   SMS_PASSWORD
#   SMS_FROM
#
# Commands:
#   hubot drunk-text <number> - send a text to <number>
#   hubot prank-text <number> - send a text to <number>
#
# Author:
#   vanetix

HTMLParser = require("htmlparser")
Select = require("soupselect").select
QueryString = require("querystring")
util = require('util')


TFLN = "http://textsfromlastnight.com/Random-Texts-From-Last-Night.html"
SMSIFIED = "https://api.smsified.com"
SMS_USERNAME = process.env.SMS_USERNAME
SMS_PASSWORD = process.env.SMS_PASSWORD
SMS_FROM = process.env.SMS_FROM


module.exports = (robot) ->
  robot.respond /(drunk-text|prank-text) (\d+)/i, (msg) ->
    number = msg.match[2]

    retrieveText msg, (text) ->
      if text is false
        msg.send "An error occurred while getting a random text."

      sendText msg, number, text, (status) ->
        if status is true
          msg.send "Message: #{text} has been sent to #{number}."
        else
          msg.send "An error occurred while sending the text."


sendText = (botHandle, to, text, callback) ->
  payload = QueryString.stringify address: to, message: text
  authString = "Basic " + new Buffer(SMS_USERNAME + ":" + SMS_PASSWORD).toString("base64")

  botHandle
    .http(SMSIFIED)
    .path("/v1/smsmessaging/outbound/#{SMS_FROM}/requests")
    .header("Authorization", authString)
    .header("Content-Type", "application/x-www-form-urlencoded")
    .post(payload) (err, res, body) ->
      if not err? and res.statusCode is 201
        callback true
      else
        callback false


retrieveText = (msg, callback) ->
  msg.http(TFLN).get() (err, res, body) ->
      if res.statusCode is not 200 or err?
        callback false
      else
        handler = new HTMLParser.DefaultHandler(((err) ->
          callback 'Problem parsing the text.' if err
          ), ignoreWhitespace: true )
        parser = new HTMLParser.Parser handler
        parser.parseComplete body
        nodes = Select handler.dom, "#texts-list li .text p a"

        callback nodes[0]?.children[0]?.data || false
