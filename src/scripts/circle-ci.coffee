# Description:
#   Find the build status of aproject on CircleCI
#
# Dependencies:
#   "gitio": "1.0.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot circle me <user>/<repo> [branch] - Returns the build status of https://github.com/<user>/<repo>
#   hubot circle last <user>/<repo> [branch] - Returns the build status of the last complete build of https://github.com/<user>/<repo>
#   hubot circle retry <user>/<repo> <build_num> - Retries the build
#   hubot circle cancel <user>/<repo> <build_num> - Cancels the build
#   hubot circle clear <user>/<repo> - Clears the cache for the specified repo
#
# Configuration:
#   HUBOT_CIRCLECI_TOKEN
#
# URLS:
#   POST /hubot/circle?room=<room>[&type=<type>]
#
# Author:
#   dylanlingelbach

url = require('url')
util = require('util')
querystring = require('querystring')
gitio = require('gitio')

circle_ci_endpoint = 'https://circleci.com/api/v1/'

module.exports = (robot) ->
  
  robot.respond /circle me (\S*)\s*(\S*)/i, (msg) ->
    project = escape(msg.match[1])
    branch = if msg.match[2] then escape(msg.match[2]) else 'master'
    msg.http("https://circleci.com/api/v1/project/#{project}/tree/#{branch}?circle-token=#{process.env.HUBOT_CIRCLECI_TOKEN}")
      .headers("Accept": "application/json")
      .get() (err, res, body) ->
        switch res.statusCode
          when 401
            msg.send 'Not authorized. Did you set HUBOT_CIRCLECI_TOKEN?'
          when 200
            response = JSON.parse(body)
            if response.length == 0
              msg.send "Current build status for #{project}(#{branch}): unknown"
            else
              last = response[0]
              msg.send "Current build status for #{project}(#{last.branch}): #{last.status} [#{last.build_num}]"
          else
            msg.send "Unknown error getting CircleCI status: #{res.statusCode}"

  robot.respond /circle last (\S*)\s*(\S*)/i, (msg) ->
    project = escape(msg.match[1])
    branch = if msg.match[2] then escape(msg.match[2]) else 'master'
    msg.http("https://circleci.com/api/v1/project/#{project}/tree/#{branch}?circle-token=#{process.env.HUBOT_CIRCLECI_TOKEN}")
      .headers("Accept": "application/json")
      .get() (err, res, body) ->
        switch res.statusCode
          when 401
            msg.send 'Not authorized. Did you set HUBOT_CIRCLECI_TOKEN?'
          when 200
            response = JSON.parse(body)
            if response.length == 0
              msg.send "Current build status for #{project}(#{branch}): unknown"
            else
              last = response[0]
              if last.status != 'running'
                msg.send "Current build status for #{project}(#{last.branch}): #{last.status} [#{last.build_num}]"
              else if last.previous && last.previous.status
                msg.send "Last build status for #{project}(#{last.branch}): #{last.previous.status} [#{last.previous.build_num}]"
              else
                msg.send "Last build status for #{project}(#{branch}): unknown"
          else
            msg.send "Unknown error getting CircleCI status: #{res.statusCode}"

  robot.respond /circle retry (.*) (.*)/i, (msg) ->
    project = escape(msg.match[1])
    if !msg.match[2]
      msg.send "I can't retry without a build number"
      return
    build_num = escape(msg.match[2])
    msg.http("https://circleci.com/api/v1/project/#{project}/#{build_num}/retry?circle-token=#{process.env.HUBOT_CIRCLECI_TOKEN}")
      .headers("Accept": "application/json")
      .post('{}') (err, res, body) ->
        switch res.statusCode
          when 401
            msg.send 'Not authorized. Did you set HUBOT_CIRCLECI_TOKEN?'
          else
            response = JSON.parse(body)
            msg.send "Retrying build #{build_num} for #{project}(#{response.branch})"

  # robot.router.post "/hubot/circle", (req, res) ->
  #   query = querystring.parse url.parse(req.url).query
  #   res.end JSON.stringify {
  #      received: true #some client have problems with an empty response
  #   }

  #   user = {}
  #   user.room = query.room if query.room
  #   user.type = query.type if query.type

  #   try
  #     payload = JSON.parse req.body.payload

  #     gitio payload.compare_url, (err, data) ->
  #       robot.send user, "#{payload.status_message.toUpperCase()} build (#{payload.build_url}) on #{payload.repository.name}:#{payload.branch} by #{payload.author_name} with commit (#{if err then payload.compare_url else data})"

  #   catch error
  #     console.log "circle hook error: #{error}. Payload: #{req.body.payload}"

