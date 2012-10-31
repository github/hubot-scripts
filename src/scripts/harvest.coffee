# Description:
#   Allows Hubot to interact with Harvest's (http://harvestapp.com) time-tracking
#   service.
#
# Dependencies:
#   None
# Configuration:
#   HUBOT_HARVEST_SUBDOMAIN
#     The subdomain you access the Harvest service with, e.g.
#     if you have the Harvest URL http://yourcompany.harvestapp.com
#     you should set this to "yourcompany" (without the quotes).
#
# Commands:
#
#   hubot remember my harvest account <email> with password <password> - Make hubot remember your Harvest credentials
#   hubot forget my harvest account - Make hubot forget your Harvest credentials again
#   hubot start harvest at <project>/<task>: <notes> - Start a Harvest timer at a given project-task combination
#   hubot stop harvest [at project/task] - Stop the most recent Harvest timer or the one for the given project-task combination.
#   hubot daily harvest [of <user>] - Show a user's Harvest timers for today (or yours, if noone is specified)
#   hubot list harvest tasks [of <user>] - Show the Harvest project-task combinations available to a user (or you, if noone is specified)
#   hubot is harvest down/up - Check if the Harvest API is reachable.
# 
# Notes:
#   All commands and command arguments are case-insenitive. If you work
#   on a project "FooBar", hubot will unterstand "foobar" as well. This
#   is also true for abbreviations, so if you don't have similary named
#   projects, "foob" will do as expected.
#
#   Some examples:
#   > hubot remember my harvest account joe@example.org with password doe
#   > hubot list harvest tasks
#   > hubot start harvest at myproject/important-task: Some notes go here.
#   > hubot start harvest at myp/imp: Some notes go here.
#   > hubot daily harvest of nickofotheruser
#
#   Full command descriptions:
#
#   hubot remember my harvest account <email> with password <password>
#     Saves your Harvest credentials to allow Hubot to track
#     time for you.
#
#   hubot forget my harvest account
#     Deletes your account credentials from Hubt's memory.
#
#   hubot start harvest at <project>/<task>: <notes>
#     Starts a timer for a task at a project (both of which may
#     be abbreviated, Hubot will ask you if your input is
#     ambigious). An existing timer (if any) will be stopped.
#
#   hubot stop harvest [at <project>/<task>]
#     Stops the timer for a task, if any. If no project is given,
#     stops the first active timer it can find. The project and
#     task arguments may be abbreviated as with start.
#
#   hubot daily harvest [of <user>]
#     Hubot responds with your/a specific user's entries
#     for today.
#
#   hubot list harvest tasks [of <user>]
#     Gives you a list of all project/task combinations available
#     to you or a specific user. You can use these for the start command.
# 
# Author:
#   Quintus @ Asquera
#
http = require("http")

unless process.env.HUBOT_HARVEST_SUBDOMAIN
  console.log "Please set HUBOT_HARVEST_SUBDOMAIN in the environment to use the harvest plugin script."

# Checks if we have the information necessary for making requests
# for a user. If we don't, reply accordingly and return null. Otherwise,
# return the user object.
# If `test_user` is supplied, checks the credentials for the user
# with that name, otherwise the sender of `msg` is checked.
check_user = (robot, msg, test_user = null) ->
  # Detect the user; if none is passed, assume the sender.
  user = null
  if test_user
    user = robot.userForName(test_user)
    unless user
      msg.reply "#{msg.match[2]}? Whoʼs that?"
      return null
  else
    user = msg.message.user
    
  # Check if we know the detected user's credentials.
  unless user.harvest_account
    if user == msg.message.user
      msg.reply "You have to tell me your Harvest credentials first."
    else
      msg.reply "I didnʼt crack #{user.name}ʼs Harvest credentials yet, but Iʼm working on it… Sorry for the inconvenience."
    return null
    
  return user

# Issues an empty GET request to harvest to test whether the service is
# available at the moment. The callback gets passed an exception object
# describing the connection error; if everything is fine it gets passed
# null.
check_harvest_down = (callback) ->
  opts =
    headers:
      "Content-Type": "application/json"
      "Accept": "application/json"
    method: "GET"
    host: "#{process.env.HUBOT_HARVEST_SUBDOMAIN}.harvestapp.com"
    port: 80
    path: "/account/who_am_i"
  req = http.request opts, (response) ->
    callback null
  req.on "error", (error) ->
    callback error
  req.setTimeout 5000, ->
    req.destroy() # Cancel the request
    callback "Connection timeout"
  req.end()

### Definitions for hubot ###
module.exports = (robot) ->

  # Periodically check the Harvest service for availability
  cb = ->
    check_harvest_down (error) ->
      if (error)
        robot.send "broadcast", "Harvest appears to be down; exact error is: #{error}"
  setInterval(cb, 600000) # 10 Minutes in milliseconds

  # Check if Harvest is available.
  robot.respond /is harvest (down|up)/i, (msg) ->
    check_harvest_down (error) ->
      if error
        msg.reply("Harvest is down; exact error: #{error}")
      else
        msg.reply("Harvest is up.")

  # Provide facility for saving the account credentials.
  robot.respond /remember my harvest account (.+) with password (.+)/i, (msg) ->
    account = new HarvestAccount msg.match[1], msg.match[2]

    # If the credentials are valid, remember them, otherwise
    # tell the user they are wrong.
    try
      account.test msg, (valid) ->
        if valid
          msg.message.user.harvest_account = account
          msg.reply "Thanks, Iʼll remember your credentials. Have fun with Harvest."
        else
          msg.reply "Uh-oh – I just tested your credentials, but they appear to be wrong. Please specify the correct ones."
    catch error
      msg.reply "Fatal error: #{error}"

  # Allows a user to delete his credentials.
  robot.respond /forget my harvest account/i, (msg) ->
    msg.message.user.harvest_account = null
    msg.reply "Okay, I erased your credentials from my memory."

  # Retrieve your or a specific user's timesheet for today.
  robot.respond /daily harvest( of (.+))?/i, (msg) ->
    unless user = check_user(robot, msg, msg.match[2])
      return

    try
      user.harvest_account.daily msg, (status, body) ->
        if 200 <= status <= 299
          msg.reply "Your entries for today, #{user.name}:"
          for entry in body.day_entries
            if entry.ended_at == ""
              msg.reply "• #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [running since #{entry.started_at} (#{entry.hours}h)]"
            else
              msg.reply "• #{entry.project} (#{entry.client}) → #{entry.task} <#{entry.notes}> [#{entry.started_at} – #{entry.ended_at} (#{entry.hours}h)]"
        else
          msg.reply "Request failed with status #{status}."
    catch error
      msg.reply("Fatal error: #{error}")

  # List all project/task combinations that are available to a user.
  robot.respond /list harvest tasks( of (.+))?/i, (msg) ->
    unless user = check_user(robot, msg, msg.match[2])
      return

    try
      user.harvest_account.daily msg, (status, body) ->
        if 200 <= status <= 299
          msg.reply "The following project/task combinations are available for you, #{user.name}:"
          for project in body.projects
            msg.reply "• Project #{project.name}"
            for task in project.tasks
              msg.reply "  ‣ #{task.name} (#{if task.billable then 'billable' else 'non-billable'})"
        else
          msg.reply "Request failed with status #{status}."
    catch error
      msg.reply "Fatal error: #{error}"

  # Kick off a new timer, stopping the previously running one, if any.
  robot.respond /start harvest at (.+)\/(.+): (.*)/i, (msg) ->
    unless user = check_user(robot, msg)
      return

    project = msg.match[1]
    task    = msg.match[2]
    notes   = msg.match[3]

    try
      user.harvest_account.start msg, project, task, notes, (status, body) ->
        if 200 <= status <= 299
          if body.hours_for_previously_running_timer?
            msg.reply "Previously running timer stopped at #{body.hours_for_previously_running_timer}h."
          msg.reply "OK, I started tracking you on #{body.project}/#{body.task}."
        else
          msg.reply "Request failed with status #{status}."
    catch error
      msg.reply "Fatal error: #{error}"

  # Stops the timer running for a project/task combination,
  # if any. If no combination is given, stops the first
  # active timer available.
  robot.respond /stop harvest( at (.+)\/(.+))?/i, (msg) ->
    unless user = check_user(robot, msg)
      return
    
    if msg.match[1]
      project = msg.match[2]
      task    = msg.match[3]
      try
        user.harvest_account.stop msg, project, task, (status, body) ->
          if 200 <= status <= 299
            msg.reply "Timer stopped (#{body.hours}h)."
          else
            msg.reply "Request failed with status #{status}."
            msg.reply body
      catch error
        msg.reply("Fatal error: #{error}")
    else
      try
        user.harvest_account.stop_first msg, (status, body) ->
          if 200 <= status <= 299
            msg.reply "Timer stopped (#{body.hours}h)."
          else
            msg.reply "Request failed with status #{status}."
      catch error
        msg.reply("Fatal error: #{error}")

# Class managing the Harvest account associated with
# a user. Keeps track of the user's credentials and can
# be used to query the Harvest API on behalf of that user.
#
# The API calls are asynchronous, i.e. the methods executing
# the request immediately return. To process the response,
# you have to attach a callback to the method call, which
# unless documtened otherwise will receive two arguments,
# the first being the response's status code, the second
# one is the response's body as a JavaScript object created
# via `JSON.parse`.
class HarvestAccount

  # Create a new harvest account. Pass in the account's email and the
  # password used to access harvest. These credentials are the same you
  # use for logging into Harvest's web service.
  constructor: (email, password) ->
    @base_url = "https://#{process.env.HUBOT_HARVEST_SUBDOMAIN}.harvestapp.com"
    @email    = email
    @password = password

  # Tests whether the account credentials are valid.
  # If so, the callback gets passed `true`, otherwise
  # it gets passed `false`.
  test: (msg, callback) ->
    this.request(msg).path("account/who_am_i").get() (err, res, body) ->
      if 200 <= res.statusCode <= 299
        callback true
      else
        callback false

  # Issues /daily to the Harvest API.
  daily: (msg, callback) ->
    this.request(msg).path("/daily").get() (err, res, body) ->
      callback res.statusCode, JSON.parse(body)

  # Issues /daily/add to the Harvest API to add a new timer
  # starting from now.
  start: (msg, target_project, target_task, notes, callback) ->
    this.find_project_and_task msg, target_project, target_task, (project, task) =>
      # OK, task and project found. Start the tracker.
      data =
        notes: notes
        project_id: project.id
        task_id: task.id
      this.request(msg).path("/daily/add").post(JSON.stringify(data)) (err, res, body) ->
        callback res.statusCode, JSON.parse(body)

  # Issues /daily/timer/<id> to the Harvest API to stop
  # the timer running at `entry.id`. If that timer isn't
  # running, replys accordingly, otherwise calls the callback
  # when the operation has finished.
  stop_entry: (msg, entry, callback) ->
    if entry.timer_started_at?
      this.request(msg).path("/daily/timer/#{entry.id}").get() (err, res, body) ->
        callback res.statusCode, JSON.parse(body)
    else
      msg.reply "This timer is not running."

  # Issues /daily/timer/<id> to the Harvest API to stop
  # the timer running at <id>, which is determined by
  # looking up the current day_entry for the given
  # project/task combination. If no entry is found (i.e.
  # no timer has been started for this combination today),
  # replies with an error message and doesn't executes the
  # callback.
  stop: (msg, target_project, target_task, callback) ->
    this.find_day_entry msg, target_project, target_task, (entry) =>
      this.stop_entry msg, entry, (status, body) -> callback status, body

  # Issues /daily/timer/<id> to the Harvest API to stop
  # the timer running at <id>, which is the first active
  # timer it can find in today's timesheet, then calls the
  # callback. If no active timer is found, replies accordingly
  # and doesn't execute the callback.
  stop_first: (msg, callback) ->
    this.daily msg, (status, body) =>
      found_entry = null
      for entry in body.day_entries
        if entry.timer_started_at?
          found_entry = entry
          break

      if found_entry?
        this.stop_entry msg, found_entry, (status, body) -> callback status, body
      else
        msg.reply "Currently there is no timer running."

  # (internal method)
  # Assembles the basic parts of a request to the Harvest
  # API, i.e. the Content-Type/Accept and authorization
  # headers. The returned HTTPClient object can (and should)
  # be customized further by calling path() and other methods
  # on it.
  request: (msg) ->
    req = msg.http(@base_url).headers
      "Content-Type": "application/json"
      "Accept": "application/json"
    .auth(@email, @password)
    return req

  # (internal method)
  # Searches through all projects available to the sender of
  # `msg` for a project whose name inclues `target_project`.
  # If exactly one is found, query all tasks available for the
  # sender in this projects, and if exactly one is found,
  # execute the callback with the project object as the first
  # and the task object as the second argument. If more or
  # less than one project or task are found to match the query,
  # reply accordingly to the user (the callback never gets
  # executed in this case).
  find_project_and_task: (msg, target_project, target_task, callback) ->
    this.daily msg, (status, body) ->
      # Search through all possible projects for the matching ones
      projects = []
      for project in body.projects
        if project.name.toLowerCase().indexOf(target_project.toLowerCase()) != -1
          projects.push(project)
      # Ask the user if the project name is ambivalent
      if projects.length == 0
        msg.reply "Sorry, no matching projects found."
        return
      else if projects.length > 1
        msg.reply "I found the following #{projects.length} projects for your query, please be more precise:"
        for project in projects
          msg.reply "• #{project.name}"
        return

      # Repeat the same process for the tasks
      tasks = []
      for task in projects[0].tasks
        if task.name.toLowerCase().indexOf(target_task.toLowerCase()) != -1
          tasks.push(task)
      if tasks.length == 0
        msg.reply "Sorry, no matching tasks found."
      else if tasks.length > 1
        msg.reply "I found the following #{tasks.length} tasks for your query, please be more pricese:"
        for task in tasks
          msg.reply "• #{task.name}"
        return

      # Execute the callback with the results
      callback projects[0], tasks[0]

  # (internal method)
  # Searches through all entries made for today and tries
  # to find a running timer for the given project/task
  # combination.
  # If it is found, the respective entry object is passed to
  # the callback, otherwise an error message is replied and
  # the callback doesn't get executed.
  find_day_entry: (msg, target_project, target_task, callback) ->
    this.find_project_and_task msg, target_project, target_task, (project, task) =>
      this.daily msg, (status, body) ->
        # For some unknown reason, the daily entry IDs are strings
        # instead of numbers, causing the comparison below to fail.
        # So, convert our target stuff to strings as well.
        project_id = "#{project.id}"
        task_id    = "#{task.id}"
        # Iterate through all available entries for today
        # and try to find the requested ID.
        found_entry = null
        for entry in body.day_entries
          if entry.project_id == project_id and entry.task_id == task_id and entry.timer_started_at?
            found_entry = entry
            break

        # None found
        unless found_entry?
          msg.reply "I couldnʼt find a running timer in todayʼs timesheet for the combination #{target_project}/#{target_task}."
          return

        # Execute the callback with the result
        callback found_entry
