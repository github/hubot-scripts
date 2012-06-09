# Description:
#   This is a basic OAuth authentication bot which is meant to be used with
#   other scripts to interact and get data via signed API requests. Script
#   has a dependency to scribe-node library that fundamentally wraps OAuth
#   routines to give simpler and maintainable development experience for coders.
#
# Dependencies:
#   "scribe-node": ">=0.0.24"
# 
# Configuration:
#   None
#
# Commands:
#   get <api> authorization url - get a link to authorization place
#   set <api> verifier <verification_code> - set verification code and access token after first step
#   set <api> access token <code> - set access token manually, for OAuth 2.0 (Facebook) only
#   refresh <api> token - refresh access token if it expires, for OAuth 2.0 only
#   get <api> request token - retrieves request token public value
#   get <api> access token - retrieves access token public value
#   get <api> verifier - retrieves verification code
#   remove <api> authorization - clears tokens from memory if user is same who verified the last authorization
# 
# Author:
#   mmstud

scribe = require('scribe-node').load(['OAuth'])
# set custom service configurations if not available from scribe OAuth widget.
# see examples and instructions from the loaded module widget itself:
# https://github.com/mmstud/scribe-node/blob/master/src/widgets/OAuth.coffee
services = {}

handle_authorization = (robot, msg) ->
  callback = (url) ->
    message = if url then url else "Error on retrieving url. See logs for more details."
    msg.send message
  new scribe.OAuth(robot.brain.data, msg.match[1].toLowerCase(), services).get_authorization_url(callback)

handle_verification = (robot, msg) ->
  api = msg.match[1].toLowerCase()
  callback = (response) ->
    if response
      if not robot.brain.data.oauth_user
        robot.brain.data.oauth_user = []
      # set up owner for authorization. affects only to removing it so far.
      # but note that someone can still overwrite authorization if wanted!
      robot.brain.data.oauth_user[api] = msg.message.user.reply_to
      message = "Verification done"
    else 
      message = "Error on verification process. See logs for more details."
    msg.send message
  new scribe.OAuth(robot.brain.data, api, services).set_verification_code(msg.match[2], callback)

handle_refresh = (robot, msg) ->
  service = new scribe.OAuth(robot.brain.data, msg.match[1].toLowerCase(), services)
  if access_token = service.get_access_token()
    callback = (response) ->
      message = if response then "Access token refreshed" else "Error on refreshing access token. See logs for more details."
      msg.send message
    service.refresh_access_token(access_token, callback)
  else
    msg.send "Access token not found"

# small factory to support both gtalk and other adapters by hearing all lines or those called by bot name only
hear_and_respond = (robot, regex, callback) ->
  robot.hear eval('/^'+regex+'/i'), callback
  robot.respond eval('/'+regex+'/i'), callback

module.exports = (robot) ->
  hear_and_respond robot, 'get ([0-9a-zA-Z].*) authorization url$', (msg) ->
    handle_authorization robot, msg

  hear_and_respond robot, 'set ([0-9a-zA-Z].*) verifier (.*)', (msg) ->
    handle_verification robot, msg

  hear_and_respond robot, 'refresh ([0-9a-zA-Z].*) token$', (msg) ->
    handle_refresh robot, msg

  hear_and_respond robot, 'get ([0-9a-zA-Z].*) request token$', (msg) ->
    if token = new scribe.OAuth(robot.brain.data, msg.match[1].toLowerCase(), services).get_request_token()
      message = "Request token: " + token.getToken()
    else
      message = "Request token not found"
    msg.send message

  hear_and_respond robot, 'get ([0-9a-zA-Z].*) access token$', (msg) ->
    if token = new scribe.OAuth(robot.brain.data, msg.match[1].toLowerCase(), services).get_access_token()
      message = "Access token: " + token.getToken()
    else
      message = "Access token not found"
    msg.send message

  hear_and_respond robot, 'get ([0-9a-zA-Z].*) verifier$', (msg) ->
    if token = new scribe.OAuth(robot.brain.data, msg.match[1].toLowerCase(), services).get_verifier()
      message = "Verifier: " + token.getValue()
    else
      message = "Verifier not found"
    msg.send message

  hear_and_respond robot, 'remove ([0-9a-zA-Z].*) authorization$', (msg) ->
    api = msg.match[1].toLowerCase()
    if robot.brain.data.oauth_user and robot.brain.data.oauth_user[api] == msg.message.user.reply_to
      message = "Authorization removed: " + new scribe.OAuth(robot.brain.data, api, services).remove_authorization()
    else
      message = "Authorization can be removed by original verifier only: " + robot.brain.data.oauth_user[api]
    msg.send message

  hear_and_respond robot, 'set ([0-9a-zA-Z].*) access token (.*)', (msg) ->
    api = msg.match[1].toLowerCase()
    if new scribe.OAuth(robot.brain.data, api, services).set_access_token_code(msg.match[2])
      robot.brain.data.oauth_user[api] = msg.message.user.reply_to
      message = "Access token set"
    else
      message = "Error on setting access token"
    msg.send message
