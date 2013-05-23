# Description:
#  Interact with Helpscout
#
# Configuration:
#   HUBOT_HELPSCOUT_API_KEY - Go to Your Profile -> API Keys
#
# Commands:
#   hubot hs mailboxes - list Helpscout mailboxes
#   hubot hs count MAILBOX_ID - Return the number of active tickets in a mailbox
#   hubot hs users MAILBOX_ID - List the number of active tickets each user has in a mailbox
#
# Author:
#   Brett Hardin (http://bretthard.in)

Util = require "util"

url = 'https://api.helpscout.net/v1'
api_key = process.env.HUBOT_HELPSCOUT_API_KEY

getRequest = (msg, path, callback) ->
  auth = 'Basic ' + new Buffer("#{api_key}:x").toString('base64')
  msg.robot.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)

module.exports = (robot) ->
  # hubot helpscout users FOLDER_ID
  robot.respond /hs users\s?(@\w+)?(.*)/i, (msg) ->
    if api_key
      mailboxId = msg.match[2] # Second Term

      getRequest msg, "/mailboxes/#{mailboxId}/conversations.json?status=active", (err, res, body) ->
        response = JSON.parse body
        users = []
        conversations = []
        
        for item in response.items
          if item.owner != null
            conversations.push { name: "#{item.owner.firstName} #{item.owner.lastName}", createdAt: item.createdAt }
          else
            conversations.push { name: 'Unassigned', createdAt: item.createdAt }

        for conversation in conversations
          for key, value of conversation
            if key == 'name' && !users[value]
              users[value] = 1
            else if key == 'name'
              users[value] += 1

        for key, value of users
          msg.send "#{key}: #{value}"

    else
      msg.send "Don't have the HUBOT_HELPSCOUT_API_KEY."

  # hubot helpscout count FOLDER_ID
  robot.respond /hs count\s?(@\w+)?(.*)/i, (msg) ->
    if api_key
      mailboxId = msg.match[2] # Second Term

      getRequest msg, "/mailboxes/" + mailboxId + "/conversations.json?status=active", (err, res, body) ->
        response = JSON.parse body
        
        msg.send response.count
    else
      msg.send "Don't have the HUBOT_HELPSCOUT_API_KEY."

  # hubot helpscout mailboxes  
  robot.respond /hs mailboxes\s?(.*)?/i, (msg) ->
    if api_key
      getRequest msg, "/mailboxes.json", (err, res, body) ->
        response = JSON.parse body
        
        for item in response.items
          msg.send "#{item.id}: #{item.name}"
    else
      msg.send "Don't have the HUBOT_HELPSCOUT_API_KEY."






