# Description
#   It provides the status and release date of a heroku app
#
# Dependencies:
#   "moment": "1.0.0"
#
# Configuration:
#   HEROKU_TOKEN
#
# Commands:
#   hubot heroku-app <app-name>
#
# Notes:
#   The comand "heroku-app" will fetch the app url, dynos status, release date
#   and who performed the released.
#
# Author:
#   mogox

module.exports = (robot) ->
  moment = require 'moment'
  robot.respond /heroku-app\s+(.*)/i, (msg) ->
    app_name = msg.match[1]
    herokuAPI(msg, "#{app_name}", appInfoHandler)
    herokuAPI(msg, "#{app_name}/dynos", appDynosHandler)

  appInfoHandler = (msg, err, res, body) ->
    if !err
      response = JSON.parse body
      txt = "Web URL: #{response['web_url']}\n"
      released_at = moment(response['released_at']).fromNow()
      txt += "Released #{released_at}"
      msg.send txt
    else
      msg.send "An error ocurred while getting the app info #{err}"

  appDynosHandler = (msg, err, res, body) ->
    if !err
      response = JSON.parse body
      txt = ""
      for dyno in response
        txt += "Dyno: #{dyno['name']} "
        txt += "State: #{dyno['state']}\n"

      msg.send txt

      if response[0]
        release = response[0]['release']['version']
        herokuAPI(msg, "#{msg.match[1]}/releases/#{release}}", appReleaseHandler) if release
    else
      msg.send "An error ocurred while getting the dynos info: #{err}"

  appReleaseHandler = (msg, err, res, body) ->
    if !err
      response = JSON.parse body
      txt = "Released by: #{response['user']['email']}"
      msg.send txt
    else
      msg.send "An error ocurred while getting the release info: #{err}"

  herokuAPI = (msg, api_action, handler) ->
    heroku_token = process.env.HEROKU_TOKEN
    robot.http("https://api.heroku.com/apps/#{api_action}")
      .headers(Accept: "application/vnd.heroku+json; version=3", Authorization: heroku_token)
      .get() (err, res, body) ->
        handler(msg, err, res, body)


