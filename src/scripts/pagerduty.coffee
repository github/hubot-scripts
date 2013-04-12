# Description:
#   PagerDuty Integration for checking who's on call, making exceptions, ack, resolve, etc.
#
# Commands:
#
#   hubot who's on call - return the username of who's on call
#   hubot pager me trigger <msg> - create a new incident with <msg>
#   hubot pager me 60 - take the pager for 60 minutes
#   hubot pager me as you@yourdomain.com - remember your pager email is you@yourdomain.com
#   hubot pager me incidents - return the current incidents
#   hubot pager me note <incident> <content> - add note to incident #<incident> with <content>
#   hubot pager me problems - return all open inicidents
#   hubot pager me ack <incident> - ack incident #<incident>
#   hubot pager me resolve <incident> - resolve incident #<incident>
#
# Dependencies:
#  "moment": "1.6.2"
# 
# Configuration:
#
#   HUBOT_PAGERDUTY_USERNAME
#   HUBOT_PAGERDUTY_PASSWORD
#   HUBOT_PAGERDUTY_SUBDOMAIN
#   HUBOT_PAGERDUTY_APIKEY     Service API Key from a 'General API Service'
#   HUBOT_PAGERDUTY_SCHEDULE_ID

inspect = require('util').inspect

moment = require('moment')

pagerDutyUsers = {}
pagerDutyUsername    = process.env.HUBOT_PAGERDUTY_USERNAME
pagerDutyPassword    = process.env.HUBOT_PAGERDUTY_PASSWORD
pagerDutySubdomain   = process.env.HUBOT_PAGERDUTY_SUBDOMAIN
pagerDutyBaseUrl     = "https://#{pagerDutySubdomain}.pagerduty.com/api/v1"
pagerDutyApiKey      = process.env.HUBOT_PAGERDUTY_APIKEY
pagerDutyScheduleId  = process.env.HUBOT_PAGERDUTY_SCHEDULE_ID

module.exports = (robot) ->
  robot.respond /pager( me)?$/i, (msg) ->
    if missingEnvironmentForApi(msg)
      return

    emailNote = if msg.message.user.pagerdutyEmail
                  "You've told me your PagerDuty email is #{msg.message.user.pagerdutyEmail}"
                else if msg.message.user.email_address
                  "I'm assuming your PagerDuty email is #{msg.message.user.email_address}. Change it with `hubot pager me as you@yourdomain.com`"
                else
                  "I don't know your PagerDuty email. Change it with `hubot pager me as you@yourdomain.com`"

    cmds = robot.helpCommands()
    cmds = (cmd for cmd in cmds when cmd.match(/(pager me |who's on call)/))
    msg.send emailNote, cmds.join("\n")

  robot.respond /pager(?: me)? as (.*)$/i, (msg) ->
    email = msg.match[1]
    msg.message.user.pagerdutyEmail = email
    msg.send "Okay, I'll remember your PagerDuty email is #{email}"

  # Assumes your Campfire usernames and PagerDuty names are identical
  robot.respond /pager( me)? (\d+)/i, (msg) ->
    withPagerDutyUsers msg, (users) ->

      userId = pagerDutyUserId(msg, users)
      return unless userId

      start     = moment().format()
      minutes   = parseInt msg.match[2]
      end       = moment().add('minutes', minutes).format()
      override  = {
        'start':     start,
        'end':       end,
        'user_id':   userId
      }
      withCurrentOncall msg, (old_username) ->
        data = { 'override': override }
        pagerDutyPost msg, "/schedules/#{pagerDutyScheduleId}/overrides", data, (json) ->
          if json.override
            start = moment(json.override.start)
            end = moment(json.override.end)
            msg.send "Rejoice, #{old_username}! #{json.override.user.name} has the pager from #{start.calendar()} until #{end.calendar()}"

  robot.respond /(pager|major)( me)? (inc|incidents|sup|problems)$/i, (msg) ->
    pagerDutyIncidents msg, (incidents) ->
      if incidents.length > 0
        buffer = "Triggered:\n----------\n"
        for junk, incident of incidents.reverse()
          if incident.status == 'triggered'
            buffer = buffer + formatIncident(incident)
        buffer = buffer + "\nAcknowledged:\n-------------\n"
        for junk, incident of incidents.reverse()
          if incident.status == 'acknowledged'
            buffer = buffer + formatIncident(incident)
        msg.send buffer
      else
        msg.send "No open incidents"

  robot.respond /(pager|major)( me)? trigger (.+)$/i, (msg) ->
    pagerDutyIntegrationAPI msg, "trigger", msg.match[3], (json) ->
      msg.reply "#{json.status}, key: #{json.incident_key}"

  robot.respond /(pager|major)( me)? ack(nowledge)? (.+)$/i, (msg) ->
    updateIncident(msg, msg.match[4], 'acknowledged')

  robot.respond /(pager|major)( me)? res(olve)?(d)? (.+)$/i, (msg) ->
    updateIncident(msg, msg.match[5], 'resolved')

  robot.respond /(pager|major)( me)? note ([\d\w]+) (.+)$/i, (msg) ->
    incidentId = msg.match[3]
    content = msg.match[4]

    withPagerDutyUsers msg, (users) ->

      userId = pagerDutyUserId(msg, users)
      return unless userId

      data =
        note:
          content: content
        requester_id: userId

      pagerDutyPost msg, "/incidents/#{incidentId}/notes", data, (json) ->
        if json && json.note
          msg.send "Got it! Note created: #{json.note.content}"
        else
          msg.send "Sorry, I couldn't do it :("


  # who is on call?
  robot.respond /who('s|s| is)? (on call|oncall)/i, (msg) ->
    withCurrentOncall msg, (username) ->
      msg.reply "#{username} is on call"

missingEnvironmentForApi = (msg) ->
  missingAnything = false
  unless pagerDutySubdomain?
    msg.send "PagerDuty Subdomain is missing:  Ensure that HUBOT_PAGERDUTY_SUBDOMAIN is set."
    missingAnything |= true
  unless pagerDutyUsername?
    msg.send "PagerDuty username is missing:  Ensure that HUBOT_PAGERDUTY_USERNAME is set."
    missingAnything |= true
  unless pagerDutyPassword?
    msg.send "PagerDuty password is missing:  Ensure that HUBOT_PAGERDUTY_PASSWORD is set."
    missingAnything |= true
  unless pagerDutyScheduleId?
    msg.send "PagerDuty schedule is missing:  Ensure that HUBOT_PAGERDUTY_SCHEDULE_ID is set."
    missingAnything |= true
  missingAnything


pagerDutyUserId = (msg, users) ->
  email  = msg.message.user.pagerdutyEmail || msg.message.user.email_address
  unless email
    msg.send "Sorry, I can't figure out your email address :( Can you tell me with `hubot pager me as you@yourdomain.com`?"
    return

  userId = users[email].id

  unless userId
    msg.send "Sorry, I couldn't find a PagerDuty user for #{email}. Double check you have a user, and that I know your PagerDuty email with `hubot pager me as you@yourdomain.com`"
    return

  userId

pagerDutyGet = (msg, url, query, cb) ->
  if missingEnvironmentForApi(msg)
    return

  auth = 'Basic ' + new Buffer(pagerDutyUsername + ':' + pagerDutyPassword).toString('base64')
  msg.http(pagerDutyBaseUrl + url)
    .query(query)
    .headers(Authorization: auth, Accept: 'application/json')
    .get() (err, res, body) ->
      json_body = null
      switch res.statusCode
        when 200 then json_body = JSON.parse(body)
        else
          console.log res.statusCode
          console.log body
          json_body = null
      cb json_body

pagerDutyPut = (msg, url, data, cb) ->
  if missingEnvironmentForApi(msg)
    return

  json = JSON.stringify(data)
  auth = 'Basic ' + new Buffer(pagerDutyUsername + ':' + pagerDutyPassword).toString('base64')
  msg.http(pagerDutyBaseUrl + url)
    .headers(Authorization: auth, Accept: 'application/json')
    .header("content-type","application/json")
    .header("content-length",json.length)
    .put(json) (err, res, body) ->
      json_body = null
      switch res.statusCode
        when 200 then json_body = JSON.parse(body)
        else
          console.log res.statusCode
          console.log body
          json_body = null
      cb json_body

pagerDutyPost = (msg, url, data, cb) ->
  if missingEnvironmentForApi(msg)
    return

  json = JSON.stringify(data)
  auth = 'Basic ' + new Buffer(pagerDutyUsername + ':' + pagerDutyPassword).toString('base64')
  msg.http(pagerDutyBaseUrl + url)
    .headers(Authorization: auth, Accept: 'application/json')
    .header("content-type","application/json")
    .header("content-length",json.length)
    .post(json) (err, res, body) ->
      json_body = null
      switch res.statusCode
        when 201 then json_body = JSON.parse(body)
        else
          console.log res.statusCode
          console.log body
          json_body = null
      cb json_body

withCurrentOncall = (msg, cb) ->
  oneHour = moment().add('hours', 1).format()
  now = moment().format()

  query = {
    since: now,
    until: oneHour,
    overflow: 'true'
  }
  pagerDutyGet msg, "/schedules/#{pagerDutyScheduleId}/entries", query, (json) ->
    if json.entries and json.entries.length > 0
      cb(json.entries[0].user.name)

withPagerDutyUsers = (msg, cb) ->
  if pagerDutyUsers['loaded'] != true
    pagerDutyGet msg, "/users", {}, (json) ->
      pagerDutyUsers['loaded'] = true
      for user in json.users
        pagerDutyUsers[user.id] = user
        pagerDutyUsers[user.email] = user
        pagerDutyUsers[user.name] = user
      cb(pagerDutyUsers)
  else
    cb(pagerDutyUsers)

pagerDutyIncidents = (msg, cb) ->
  query =
    status:  "triggered,acknowledged"
    sort_by: "incident_number:asc"
  pagerDutyGet msg, "/incidents", query, (json) ->
    cb(json.incidents)

pagerDutyIntegrationAPI = (msg, cmd, args, cb) ->
  unless pagerDutyApiKey?
    msg.send "PagerDuty API service key is missing."
    msg.send "Ensure that HUBOT_PAGERDUTY_APIKEY is set."
    return

  data = null
  switch cmd
    when "trigger"
      data = JSON.stringify { service_key: pagerDutyApiKey, event_type: "trigger", description: "#{args}"}
      pagerDutyIntergrationPost msg, data, (json) ->
        cb(json)

formatIncident = (inc) ->
   # { pd_nagios_object: 'service',
   #   HOSTNAME: 'fs1a',
   #   SERVICEDESC: 'snapshot_repositories',
   #   SERVICESTATE: 'CRITICAL',
   #   HOSTSTATE: 'UP' },
  if inc.incident_number
    if inc.trigger_summary_data.description
      "#{inc.incident_number}: #{inc.trigger_summary_data.description} - assigned to #{inc.assigned_to_user.name}\n"
    else if inc.trigger_summary_data.pd_nagios_object == 'service'
       "#{inc.incident_number}: #{inc.trigger_summary_data.HOSTNAME}/#{inc.trigger_summary_data.SERVICEDESC} - assigned to #{inc.assigned_to_user.name}\n"
    else if inc.trigger_summary_data.pd_nagios_object == 'host'
       "#{inc.incident_number}: #{inc.trigger_summary_data.HOSTNAME}/#{inc.trigger_summary_data.HOSTSTATE} - assigned to #{inc.assigned_to_user.name}\n"
  else
    ""

updateIncident = (msg, incident_number, status) ->
  pagerDutyIncidents msg, (incidents) ->
    foundIncidents = []
    for incident in incidents
      if "#{incident.incident_number}" == incident_number
        foundIncidents = [ incident ]
        # loljson
        data = {
          incidents: [
            {
              'id':     incident.id,
              'status': status
            }
          ]
        }
        pagerDutyPut msg, "/incidents", data, (json) ->
          if incident = json.incidents[0]
            msg.reply "Incident #{incident.incident_number} #{incident.status}."
          else
            msg.reply "Problem updating incident #{incident_number}"
    if foundIncidents.length == 0
      msg.reply "Couldn't find incident #{incident_number}"


pagerDutyIntergrationPost = (msg, json, cb) ->
  msg.http('https://events.pagerduty.com/generic/2010-04-15/create_event.json')
    .header("content-type","application/json")
    .header("content-length",json.length)
    .post(json) (err, res, body) ->
      switch res.statusCode
        when 200
          json = JSON.parse(body)
          cb(json)
        else
          console.log res.statusCode
          console.log body
