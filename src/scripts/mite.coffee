# Description:
#   Allows Hubot to start and stop project time in mite.yo.lk
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot save my mite key <key> for <account> - stores your personal API key for mite.yo.lk
#   hubot mite me <task> on <project> - starts or stops the matched task on the given project in mite.yo.lk
#
# Author:
#   canclini

module.exports = (robot) ->
  robot.respond /mite( me)? (.+) on (.+)/i, (msg) ->            # user wants to track time
    [task, project] = msg.match[2..3]
    
    user_mite = msg.message.user.mite

    unless user_mite? and user_mite.length == 2                 # exit if the credentials are not provided
      msg.reply "sorry, you first have to tell me your credentials."
      return
    
    [mite_key, mite_account] = user_mite[0..1]                  #ok, credentials are there...

    mite = new Mite msg, mite_key, mite_account                 # create a new Mite instance
    mite.projects msg, project, (projects) ->                        # first get the project information
      if projects.length == 0                                   # no projects found
        msg.reply "Oops.. could not find a matching project"
        return
      if projects.length > 1                                    # more than one project found
        answer = "please be more precise, I found #{projects.length} projects: "
        result = (project.project.name for project in projects)
        answer += result.join(", ")
        msg.reply answer                                        # list the found projects and..
        return                                                  # .. exit
      project = projects[0].project                             # the first and only project is used
      mite.services msg,task, (services) ->                         # then get the task
        if services.length == 0
          msg.reply "Oops.. could not find a matching task"
          return
        if services.length > 1
          answer = "please be more precise, I found #{services.length} tasks: "
          result = (service.service.name for service in services)
          answer += result.join(", ")
          msg.reply answer
          return
        service = services[0].service
        # check if there is alreday a good time entry for today
        mite.todays_matching_entry msg, project, service, (time_entry) ->
          if time_entry?                                        # if there is an existing time entry for today...
            mite.tracker msg, time_entry                             # we start the timer on this one again
          else
            mite.time_entry msg, project, service, (time_entry) ->   # create a new entry for this projects task
              mite.tracker msg, time_entry                           # start the tracker on the time entry
      
# we need to know the key to connect to mite.yo.lk
  robot.respond /save my mite key (.+) for (.+)/i, (msg) ->
    mite_key = msg.match[1]                                     # the key we should keep in mind
    mite_account = msg.match[2]                                 # and the account 
    user   = msg.message.user                                   # for this user
    
    user.mite = [mite_key, mite_account]                        # and in the Brain it goes
    msg.reply "I'll hapilly punch your timecard from now on."

# MITE CLASS #
class Mite
  constructor: (msg, key, account) ->
    @url = "http://#{account}.mite.yo.lk"
    @key = key

  services: (msg, task, callback) ->
    msg
      .http(@url)
      .headers
        'X-MiteApiKey': "#{@key}",
        'Accept': 'application/json'
      .query
        name: task
      .path("services")
      .get() (err, res, body) ->
        if err
          msg.reply "Mite says: #{err}"
          return
        callback JSON.parse body

  projects: (msg, project, callback) ->
    msg
      .http(@url)
      .headers
        'X-MiteApiKey': "#{@key}",
        'Accept': 'application/json'
      .query
        name: project
      .path("projects")
      .get() (err, res, body) ->
        if err
          msg.reply "Mite says: #{err}"
          return
        callback JSON.parse body
   
  time_entry: (msg, project, service, callback) ->
    data = JSON.stringify {time_entry: {service_id: "#{service.id}", project_id: "#{project.id}"}}
    msg
      .http(@url)
      .headers
        'X-MiteApiKey': "#{@key}",
        'Content-type': "application/json",
        'Accept': 'application/json'
      .path("time_entries")
      .post(data) (err, res, body) ->
        if err
          msg.reply "Mite says: #{err}"
          return
        time_entries = JSON.parse body
        callback time_entries.time_entry

  todays_matching_entry: (msg, project, service, callback) ->
    msg
      .http(@url)
      .headers
        'X-MiteApiKey': "#{@key}",
        'Accept': 'application/json'
      .query
        name: project
      .path("daily")
      .get() (err, res, body) ->
        if err
          msg.reply "Mite says: #{err}"
          return
        time_entries = JSON.parse body
        time_entry = (t_entries.time_entry for t_entries in time_entries when t_entries.time_entry.project_id == project.id and t_entries.time_entry.service_id == service.id)
        callback time_entry[0]
   
  tracker: (msg, time_entry) ->
    msg
      .http(@url)
      .headers
        'X-MiteApiKey': "#{@key}",
        'Content-type': "application/json",
        'Accept': 'application/json'
      .path("tracker/#{time_entry.id}")
      .put(" ") (err, res, body) ->
        if err
          msg.reply "Mite says: #{err}"
          return
        msg.reply "ok, time is running..."
