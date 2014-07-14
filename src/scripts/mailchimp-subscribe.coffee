# Description:
#   Add email to Mailchimp list
#
# Dependencies:
#   "mailchimp": "1.1.0"
#
# Configuration:
#   MAILCHIMP_API_KEY
#   MAILCHIMP_LIST_ID
#
# Commands:
#   hubot subscribe <email> - Add email to list
#
# Author:
#   max, lmarburger

MailChimpAPI = require('mailchimp').MailChimpAPI

apiKey = process.env.MAILCHIMP_API_KEY
listId = process.env.MAILCHIMP_LIST_ID

module.exports = (robot)->
    robot.respond /subscribe (.+@.+)/i, (message)->
      subscribeToList message

subscribeToList = (message) ->
  emailAddress = message.match[1]

  try
    api = new MailChimpAPI(apiKey,
      version: "1.3"
      secure: false
    )
  catch error
    console.log error.message
    return

  api.listSubscribe
    id:            listId
    email_address: emailAddress
    double_optin:  false
  , (error, data) ->
    if error
      message.send "Uh oh, something went wrong: #{error.message}"
    else
      message.send "You succesfully subscribed #{emailAddress}."
