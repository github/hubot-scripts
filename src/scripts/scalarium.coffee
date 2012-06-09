# Description:
#   Interact with Scalarium cloud hosting
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SCALARIUM_TOKEN: for authenticating the requests (see https://manage.scalarium.com/users/<user-id>/api)
#
# Commands:
#   hubot scalarium list (apps|clouds) - Lists all applications/clouds on scalarium
#   hubot scalarium deploy <app id> <message> - Triggers an deployment of *app id* with *message*
#
# Author:
#   nesQuick

https = require 'https'
token = process.env.HUBOT_SCALARIUM_TOKEN

class ScalariumClient

  constructor: (@https, @token) ->

  getApplications: (cb) ->
    @request '/applications', 'GET', {}, cb

  getClouds: (cb) ->
    @request '/clouds', 'GET', {}, cb

  deploy: (appId, msg, cb, finishedCb) ->
    that = this
    @request "/applications/#{appId}/deploy", 'POST', {command: 'deploy', comment: "Hubot deploy - #{msg}"}, (result) ->
      that.registerRunningDeploy(result, finishedCb)
      cb result

  registerRunningDeploy: (deploy, cb) ->
    that = this
    intervalId = setInterval () ->
      that.request "/applications/#{deploy.application_id}/deployments/#{deploy.id}", 'GET', {}, (result) ->
        if result.status isnt 'running'
          cb result
          clearInterval intervalId
    , 10000

  request: (path, method, body, cb) ->
    options =
      host: 'manage.scalarium.com'
      method: method
      path: "/api#{path}"
      headers:
        'X-Scalarium-Token': @token
        Accept: 'application/vnd.scalarium-v1+json'
    req = @https.request options, (res) ->
      data = ''
      res.on('data', (chunk) -> data = "#{data}#{chunk}")
      res.on('end', () -> cb JSON.parse data)
    req.write JSON.stringify body
    req.end()

client = new ScalariumClient https, token

module.exports = (robot)->

  robot.respond /scalarium list apps/i, (message)->
    client.getApplications (apps) ->
      for app in apps
        message.send "#{app.name} - #{app.id}"

  robot.respond /scalarium list clouds/i, (message)->
    client.getClouds (clouds) ->
      for cloud in clouds
        message.send "#{cloud.name} - #{cloud.id}"

  robot.respond /scalarium deploy ([0-9a-f]+) (.+)$/i, (message)->
    client.deploy message.match[1], message.match[2], (deploy) ->
      message.send "Yes Sir! Deployment triggered with id #{deploy.id}. Will drop a note when it's done."
    , (finished) ->
      success = finished.status == 'successful'
      message.send """#{if success then 'Success' else 'FAIL! FAIL! FAIL!!'}! Your deployment "#{finished.comment}" with id #{finished.id} #{if success then 'is done' else 'failed'}."""

  robot.scalarium =
    getApplications: client.getApplications
    getClouds: client.getClouds
