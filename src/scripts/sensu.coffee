# Description:
#   Allows Hubot to interact with Sensu
#
# Dependencies:
#   jQuery
#
# Configuration
#   HUBOT_SENSU_URL (e.g. https://sensu.example.com)
#   HUBOT_SENSU_PORT (e.g. 8443)
#
# TODO
#   HUBOT_SENSU_AUTH (e.g. user:password for Basic Auth)
#
# Commands:
#  sensu help 
#  sensu show version 
#  sensu show stashes
#  sensu show (warn|crit|unknown) events 
#  sensu ack event <path> [reason] [expire] 
#  sensu resolve event <client> <check>
#  sensu rm stash <path>
#
# Author:
#   Rick Briganti <jeviolle@newaliases.org>

jq = require("jQuery")

module.exports = (robot) ->
  robot.respond /sensu help/i, (msg) ->
    msg.reply """
              sensu help - shows help (this)
              sensu show version - displays version of sensu
              sensu show stashes - retrieves and displays stashes
              sensu show (warn|crit|unknown) events - show current events (severity filter optional)
              sensu ack event <path> "reason" expire_in_sec - stashes an alert, set expire -1 = forver
              sensu resolve event <client> <check> - resolves an event
              sensu rm stash <path> - removes an existing stash
              """
  robot.respond /sensu rm stash (.*)/i, (msg) ->
    check_path = msg.match[1]
    stashedUrl = "/stashes/" + check_path
    construct_url msg, stashedUrl, (url) ->
      delete_url msg, url, (httpCode) ->
        if httpCode == 204
          msg.reply "stash removed successfully"
        else
          msg.reply "failed to remove stash [" + httpCode + "]"

  robot.respond /sensu ack event (.*) \"(.*)\" (.*)/i, (msg) ->
    check_path = msg.match[1]
    stash_reason = msg.match[2] 
    stash_expiration = msg.match[3]
    post_data = '{ "path": "silence/' + check_path + '", "expire": ' + stash_expiration + ', "content": { "reason": "' + stash_reason + '" } }'
    construct_url msg, "/stashes", (url) ->
      post_url msg, url, post_data, (httpCode) ->
        if httpCode == 201
          msg.reply "event ack successful"
        else
          msg.reply "failed to ack event [" + httpCode + "]"

  robot.respond /sensu resolve event (.*?) (.*)/i, (msg) ->
    client = msg.match[1]
    check = msg.match[2]
    post_data = '{ "client": "' + client + '", "check": "' + check + '"}'
    construct_url msg, "/resolve", (url) ->
      post_url msg, url, post_data, (httpCode) ->
        if httpCode == 202
          msg.reply "event resolved"
        else
          msg.reply "failed to resolve event [" + httpCode + "]"

  robot.respond /sensu show version/i, (msg) ->
    construct_url msg, "/info", (url) ->
      get_url msg, url, (results) ->
        isJSON results, (valid) ->
          if valid == true 
            jObj = jq.parseJSON(results)
            msg.reply "Sensu version: " + jObj.sensu['version']
          else
            msg.reply results

  robot.respond /sensu show stashes/i, (msg) ->
    construct_url msg, "/stashes", (url) ->
      get_url msg, url, (results) ->
        isJSON results, (valid) ->
          if valid == true
            jObj = jq.parseJSON(results)
            jq.each jObj, (idx, obj) ->
              if obj.content['timestamp']
                msg.reply "Silenced at: " + obj.content['timestamp'] + " - " + obj.path
              else
                msg.reply "Silenced because: " + obj.content['reason'] + " - " + obj.path
          else
            msg.reply results

  robot.respond /sensu show\s?(warn|crit|unknown)? events/i, (msg) ->
    construct_url msg, "/events", (url) ->
      get_url msg, url, (results) ->
        isJSON results, (valid) ->
          if valid == true
            jObj = jq.parseJSON(results)
            jq.each jObj, (idx, obj) ->
              check = ""
              output = ""
              flapping = ""
              occurences = ""
              if msg.match[1] == "warn"
                if obj.status == 1
                  msg.reply "path: " + obj.client + "/" + obj.check + "\ncheck_output: " + obj.output 
              else if msg.match[1] == "crit"
                if obj.status == 2
                  msg.reply "path: " + obj.client + "/" + obj.check + "\ncheck_output: " + obj.output 
              else if msg.match[1] == "unknown"
                if obj.status == 3
                  msg.reply "path: " + obj.client + "/" + obj.check + "\ncheck_output: " + obj.output 
              else
                msg.reply "path: " + obj.client + "/" + obj.check + "\ncheck_output: " + obj.output 

          else
            msg.reply results


isJSON = (data, cb) ->
    isJson = false
    try 
      json = jq.parseJSON(data)
      isJson = typeof json == 'object'
    catch error 
      console.error('data is not JSON')
      console.error error
    
    return cb isJson

get_url = (msg, apiUrl, cb) ->
  #auth = 'Basic ' + new Buffer(process.env.HUBOT_SENSU_AUTH).toString('base64') if process.env.HUBOT_SENSU_AUTH
  msg.http(apiUrl)
    .header('User-Agent', 'Hubot Sensu Script')
    #.headers(Authorization: auth if auth, Accept: 'application/json', 'User-Agent': 'Hubot Sensu Script', 'Content-type': 'application/json')
    .get() (err, res, body) ->
      return cb "Oh noes! Failure to launch.." if err
      if res.statusCode != 200
        cb "Ugh, I think something went wrong: " + res.statusCode 
      else
        cb body

post_url = (msg, apiUrl, jsonData, cb) ->
  msg.http(apiUrl)
    .header('User-Agent', 'Hubot Sensu Script')
    .post(jsonData) (err, res, body) ->
      if err
        msg.reply "Encountered an error :( #{err}"
        return cb "000"
      cb res.statusCode 

delete_url = (msg, apiUrl, cb) ->
  msg.http(apiUrl)
    .header('User-Agent', 'Hubot Sensu Script')
    .del() (err, res, body) ->
      if err
        msg.reply "Encountered an error :( #{err}"
        return cb "000"
      cb res.statusCode

construct_url = (msg, apiUrl, cb) ->
  serverRegex = /(\bhttps?:\/\/)(\S+)$/
  proto = process.env.HUBOT_SENSU_URL.match(serverRegex)[1]
  server = process.env.HUBOT_SENSU_URL.match(serverRegex)[2]
  port = contruct_port()
  newUrl = proto + process.env.HUBOT_SENSU_AUTH + "@" + server + port + apiUrl
  cb newUrl

contruct_port = () ->
  port = ":"
  if process.env.HUBOT_SENSU_PORT
    port += process.env.HUBOT_SENSU_PORT
  else if process.env.HUBOT_SENSU_URL.match(/https/)
    port += 443
  else 
    port += 80
  port

