# Description:
#   wrapper for TeamCity REST API
#
# Dependencies:
#   "underscore": "1.3.3"
#
# Configuration:
#   HUBOT_TEAMCITY_USERNAME = <user name>
#   HUBOT_TEAMCITY_PASSWORD = <password>
#   HUBOT_TEAMCITY_HOSTNAME = <host : port>
#
# Commands:
#   hubot show me builds - Show status of currently running builds
#   hubot tc list projects - Show all available projects
#   hubot tc list buildTypes - Show all available build types
#   hubot tc list builds <buildType> - Show the status of the last 5 builds 
#   hubot tc build start <buildType> - Adds a build to the queue for the specified build type
#
# Author:
#   Micah Martin

util  = require 'util'
_     = require 'underscore'

module.exports = (robot) ->
  username = process.env.HUBOT_TEAMCITY_USERNAME
  password = process.env.HUBOT_TEAMCITY_PASSWORD
  hostname = process.env.HUBOT_TEAMCITY_HOSTNAME

  buildTypes = []

  getAuthHeader = ->
    return Authorization: "Basic #{new Buffer("#{username}:#{password}").toString("base64")}", Accept: "application/json"

  getBuildType = (msg, type, callback) ->
    url = "http://#{hostname}/httpAuth/app/rest/buildTypes/#{type}"
    console.log "sending request to #{url}"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        callback err, body, msg

  getCurrentBuild = (msg, type, callback) ->
    url = "http://#{hostname}/httpAuth/app/rest/builds/?locator=buildType:#{type},running:true"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        callback err, body, msg


  getProjects = (msg, callback) ->
    url = "http://#{hostname}/httpAuth/app/rest/projects"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
         err = body unless res.statusCode == 200
         projects = JSON.parse(body).project unless err
         callback err, msg, projects

  getBuildTypes = (msg, callback) ->
    url = "http://#{hostname}/httpAuth/app/rest/buildTypes"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
         err = body unless res.statusCode == 200
         buildTypes = JSON.parse(body).buildType unless err
         callback err, msg, buildTypes

   getBuilds = (msg, id, type, callback) ->
    url = "http://#{hostname}/httpAuth/app/rest/buildTypes/#{type}:#{escape(id)}/builds"
    msg.http(url)
      .headers(getAuthHeader())
      .query(locator: ["lookupLimit:5","running:any"].join(","))
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        builds = JSON.parse(body).build unless err
        callback err, msg, builds

  mapNameToIdForBuildType = (msg, name, callback) ->

    execute = (buildTypes) ->
      buildType =  _.find buildTypes, (bt) -> return bt.name == name
      if buildType
        return buildType.id

    result = execute(buildTypes)

    if result
      callback(msg, result)
      return

    getBuildTypes msg, (err, msg, buildTypes) ->
      callback msg, execute(buildTypes)

  robot.respond /tc build start (.*)/i, (msg) ->
    buildName = msg.match[1]
    mapNameToIdForBuildType msg, buildName, (msg, buildType) ->
      if not buildType
        msg.send "Build type #{buildName} was not found"
        return

      url = "http://#{hostname}/httpAuth/action.html?add2Queue=#{buildType}"
      msg.http(url)
        .headers(getAuthHeader())
        .get() (err, res, body) ->
          err = body unless res.statusCode == 200
          if err
            msg.send "Fail! Something went wrong. Couldn't start the build for some reason"
          else
            msg.send "Dropped a build in the queue for #{buildName}. Run `tc list builds #{buildName}` to check the status"



  robot.respond /tc list (projects|buildTypes|builds) ?(.*)?/i, (msg) ->
    type = msg.match[1]

    option = msg.match[2]
    switch type
      when "projects"
        getProjects msg, (err, msg, projects) ->
          message = ""
          for project in projects
            message += project.name + "\n"
          msg.send message

      when "buildTypes"
        getBuildTypes msg, (err, msg, buildTypes) ->
          message = ""
          for buildType in buildTypes
            message += buildType.name + "\n"
          msg.send message

      when "builds"
        getBuilds msg, option, "name", (err, msg, builds) ->
          if not builds
            msg.send "Could not find builds for #{option}"
            return

          for build in builds             
            baseMessage = "##{build.number} of #{build.branchName} #{build.webUrl}"
            if build.running
              status = if build.status == "SUCCESS" then "**Winning**" else "__FAILING__"
              message = "#{status} #{build.percentageComplete}% Complete :: #{baseMessage}"
            else
              status = if build.status == "SUCCESS" then "OK!" else "__FAILED__"
              message = "#{status} :: #{baseMessage}"

            msg.send message