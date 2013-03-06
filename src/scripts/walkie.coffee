# Description:
#   Stay up-to-date on Basecamp projects
#   Powered by http://developer.github.com/v3/repos/hooks/
#
# Dependencies:
#   "strftime": "0.5.0"
#   "string": "1.2.1"
#
# Configuration:
#   HUBOT_WALKIE_USERNAME - Basecamp account username
#   HUBOT_WALKIE_PASSWORD - Basecamp account password
#   HUBOT_WALKIE_ROOMS - comma-separated list of rooms
#
# Commands:
#   hubot walkie on <projectURL> - Start watching events for the project
#   hubot walkie off <projectURL> - Stop watching events for the project
#
# Author:
#   tybenz

strftime = require 'strftime'
S = require 'string'

module.exports = (robot) ->

  if process.env.HUBOT_WALKIE_ROOMS
    allRooms = process.env.HUBOT_WALKIE_ROOMS.split(',')
  else
    allRooms = []

  user = process.env.HUBOT_WALKIE_USERNAME
  pass = process.env.HUBOT_WALKIE_PASSWORD
  if user and pass
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64')
  format = "%Y-%m-%dT%H:%M:%S%z"

  interval = (ms, func) -> setInterval func, ms

  # Actual listener
  startListening = ->
    # Only start listening if our auth is set up. I.E. Configs have been set
    if (auth)
      interval 10000, ->
        listeners = robot.brain.data.walkie
        for i, project of listeners
          project = JSON.parse project
          robot.http("https://basecamp.com/#{project.accountID}/api/v1/projects/#{project.projectID}/events.json?since=#{project.timestamp}")
            .headers(Authorization: auth, Accept: 'application/json', 'User-Agent': 'Walkie (http://walkie.tybenz.com)')
            .get() (err, res, body) ->
              switch res.statusCode
                when 200
                  events = JSON.parse(body)
                  project.timestamp = strftime format
                  listeners[i] = JSON.stringify project
                  for event, i in events
                    message = "Walkie: [#{project.projectName}] #{event.creator.name} #{event.summary}: #{event.url.replace( /api\/v1\//, '' ).replace(/\.json/g,'')}"
                    message = S(message).unescapeHTML().s.replace( /(<([^>]+)>)/ig,"" )
                    robot.messageRoom allRooms, message
                else
                  console.log "Issue with connection to Basecamp#{body}"
    else
      console.log "Walkie: configs are not set"

  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    robot.brain.data.walkie ||= {}
    startListening()

  # Start listening for events on project
  robot.respond /walkie on ([\S]*)/i, (msg) ->
    if not(user and pass and allRooms.length > 0)
      msg.send "Walkie's config variables are not set"
    else
      url = msg.match[1]
      if /http(s)?\:\/\//.test(url)
        accountID = parseInt url.match(/\.com\/([0-9]*)\//)[1]
        projectID = parseInt url.match(/projects\/([0-9]*)-/)[1]
        msg.http("https://basecamp.com/#{accountID}/api/v1/projects.json")
          .headers(Authorization: auth, Accept: 'application/json', 'User-Agent': 'Walkie (http://walkie.tybenz.com)')
          .get() (err, res, body) ->
            switch res.statusCode
              when 200
                projects = JSON.parse(body)
                target = false
                for p, i in projects
                  if p.id is projectID
                    target = p
                if target
                  robot.brain.data.walkie["#{accountID}/#{projectID}"] = JSON.stringify { projectName: target.name, accountID: accountID, projectID: projectID, timestamp: strftime(format) }
                  msg.send "Walkie is scanning on #{target.name}"
                else
                  msg.send "Walkie could not find a project with that ID"
              else
                msg.send "Walkie was unable to find that frequency. WTF Basecamp?!? #{body}"
      else
        msg.send "Not a valid URL. Try again"

  # Stops listening for events on project
  robot.respond /walkie off ([\S]*)/i, (msg) ->
    if not(user and pass and allRooms.length > 0)
      msg.send("Walkie's config variables are not set")
    else
      url = msg.match[1]
      if /http(s)?\:\/\//.test(url)
        accountID = url.match(/\.com\/([0-9]*)\//)[1]
        projectID = url.match(/projects\/([0-9]*)-/)[1]
        if robot.brain.data.walkie["#{accountID}/#{projectID}"]?
          msg.send "Walkie has stopped scanning on #{JSON.parse(robot.brain.data.walkie["#{accountID}/#{projectID}"]).projectName}"
          delete robot.brain.data.walkie["#{accountID}/#{projectID}"]
        else
          msg.send "Walkie was not scanning on that project."
      else
        msg.send "Not a valid URL. Try again"

  # Debugging purposes grab hash stored in brain
  robot.respond /walkie fetch ([\S]*)/i, (msg) ->
    fetch = msg.match[1]
    data = robot.brain.data.walkie[fetch]
    if data
      msg.send data
    else
      msg.send "#{fetch} could not be found"

  # Stop listening to all projects (clear brain)
  robot.respond /walkie clear/i, (msg) ->
    for i, item of robot.brain.data.walkie
      delete robot.brain.data.walkie[i]
    msg.send "Walkie is turning off and will stop scanning on all projects."
