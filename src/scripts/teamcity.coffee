# Description:
#   wrapper for TeamCity REST API
#
# Dependencies:
#   "underscore": "1.3.3"
#   "async": "0.2.7"
#
# Configuration:
#   HUBOT_TEAMCITY_USERNAME = <user name>
#   HUBOT_TEAMCITY_PASSWORD = <password>
#   HUBOT_TEAMCITY_HOSTNAME = <host : port>
#   HUBOT_TEAMCITY_SCHEME = <http || https> defaults to http if not set.
#
# Commands:
#   hubot show me builds - Show status of currently running builds
#   hubot tc list projects - Show all available projects
#   hubot tc list buildTypes - Show all available build types
#   hubot tc list buildTypes of <project> - Show all available build types for the specified project
#   hubot tc list builds <buildType> <number> - Show the status of the last <number> builds. Number defaults to five.
#   hubot tc list builds of <buildType> of <project> <number>- Show the status of the last <number> builds of the specified build type of the specified project. <number> Defined to 5
#   hubot tc build start <buildType> - Adds a build to the queue for the specified build type
#   hubot tc build start <buildType> of <project> - Adds a build to the queue for the specified build type of the specified project
#   hubot tc build stop all <buildType> of <project> - Stops all currently running builds of a given buildType. Project parameter is optional.
#   hubot tc build stop <buildType> <buildId> of <project> - Stops the build type of project with the buildId if currently running. Project parameter is optional.
#
# Authors:
#   Micah Martin and Jens Jahnke
#Contributors:
#   Abraham Polishchuk

util           = require 'util'
_              = require 'underscore'
asynchron      = require 'async'

module.exports = (robot) ->
  username = process.env.HUBOT_TEAMCITY_USERNAME
  password = process.env.HUBOT_TEAMCITY_PASSWORD
  hostname = process.env.HUBOT_TEAMCITY_HOSTNAME
  scheme = process.env.HUBOT_TEAMCITY_SCHEME || "http"
  base_url = "#{scheme}://#{hostname}"

  buildTypes = []

  getAuthHeader = ->
    return Authorization: "Basic #{new Buffer("#{username}:#{password}").toString("base64")}", Accept: "application/json"

  getBuildType = (msg, type, callback) ->
    url = "#{base_url}/httpAuth/app/rest/buildTypes/#{type}"
    console.log "sending request to #{url}"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        callback err, body, msg

  getCurrentBuilds = (msg, type, callback) ->
    if (arguments.length == 2)
      if (Object.prototype.toString.call(type) == "[object Function]")
        callback = type
        url = "http://#{hostname}/httpAuth/app/rest/builds/?locator=running:true"
    else
      url = "http://#{hostname}/httpAuth/app/rest/builds/?locator=buildType:#{type},running:true"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        callback err, body, msg


  getProjects = (msg, callback) ->
    url = "#{base_url}/httpAuth/app/rest/projects"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        projects = JSON.parse(body).project unless err
        callback err, msg, projects

  getBuildTypes = (msg, project, callback) ->
    projectSegment = ''
    if project?
      projectSegment = '/projects/name:' + encodeURIComponent project
    url = "#{base_url}/httpAuth/app/rest#{projectSegment}/buildTypes"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        buildTypes = JSON.parse(body).buildType unless err
        callback err, msg, buildTypes

  getBuilds = (msg, project, configuration, callback) ->
    projectSegment = ''
    if project?
      projectSegment = "/projects/name:#{encodeURIComponent(project)}"

    url = "#{base_url}/httpAuth/app/rest#{projectSegment}/buildTypes/name:#{encodeURIComponent(configuration)}/builds"
    msg.http(url)
      .headers(getAuthHeader())
      .query(locator: ["lookupLimit:5","running:any"].join(","))
      .get() (err, res, body) ->
        err = body unless res.statusCode == 200
        builds = JSON.parse(body).build unless err
        callback err, msg, builds

  mapNameToIdForBuildType = (msg, project, name, callback) ->

    execute = (buildTypes) ->
      buildType =  _.find buildTypes, (bt) -> return bt.name == name and (not project? or bt.projectName == project)
      if buildType
        return buildType.id

    result = execute(buildTypes)

    if result
      callback(msg, result)
      return

    getBuildTypes msg, project, (err, msg, buildTypes) ->
      callback msg, execute(buildTypes)

  mapBuildToName = (build, callback) ->
    id = build['buildTypeId']
    msg = build['messengerBot']
    url = "http://#{hostname}/httpAuth/app/rest/buildTypes/id:#{id}"
    msg.http(url)
      .headers(getAuthHeader())
      .get() (err, res, body) ->
        err = body unless res.statusCode = 200
        unless err
          buildName = JSON.parse(body).name
          baseMessage = "##{build.number} of #{buildName} #{build.webUrl}"
          if build.running
            status = if build.status == "SUCCESS" then "**Winning**" else "__FAILING__"
            message = "#{status} #{build.percentageComplete}% Complete :: #{baseMessage}"
          else
            status = if build.status == "SUCCESS" then "OK!" else "__FAILED__"
            message = "#{status} :: #{baseMessage}"
          callback null, message
        else
          callback err, null

  createAndPublishBuildMap = (builds, msg, callback) ->
    for build in builds
      build['messengerBot'] = msg
    asynchron.map(builds, mapBuildToName, (err, results) ->
      for result in results
        msg.send result

    )


  robot.respond /show me builds/i, (msg) ->
    getCurrentBuilds msg, (err, builds, msg) ->
      if typeof(builds)=='string'
        builds=JSON.parse(builds)
      if builds['count']==0
        msg.send "No builds are currently running"
        return

      createAndPublishBuildMap(builds['build'], msg, (err, msg, message)->
        msg.send message
      )

  robot.respond /tc build start (.*)/i, (msg) ->
    configuration = buildName = msg.match[1]
    project = null
    buildTypeRE = /(.*?) of (.*)/i

    buildTypeMatches = buildName.match buildTypeRE
    if buildTypeMatches?
      configuration = buildTypeMatches[1]
      project = buildTypeMatches[2]

    mapNameToIdForBuildType msg, project, configuration, (msg, buildType) ->
      if not buildType
        msg.send "Build type #{buildName} was not found"
        return

      url = "#{base_url}/httpAuth/action.html?add2Queue=#{buildType}"
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
        project = null
        if option?
          projectRE = /^\s*of (.*)/i
          matches = option.match(projectRE)
          if matches? and matches.length > 1
            project = matches[1]

        getBuildTypes msg, project, (err, msg, buildTypes) ->
          message = ""
          for buildType in buildTypes
            message += "#{buildType.name} of #{buildType.projectName}\n"
          msg.send message

      when "builds"
        configuration = option
        project = null

        buildTypeRE = /^\s*of (.*?) of (.*)/i

        buildTypeMatches = option.match buildTypeRE
        if buildTypeMatches?
          configuration = buildTypeMatches[1]
          project = buildTypeMatches[2]
        else
          buildTypeRE = /^\s*of (.*)/i
          buildTypeMatches = option.match buildTypeRE
          if buildTypeMatches
            configuration = buildTypeMatches[1]
            project = null

        getBuilds msg, project, configuration, (err, msg, builds) ->
          if not builds
            msg.send "Could not find builds for #{option}"
            return
          createAndPublishBuildMap(builds, msg)
