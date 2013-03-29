# Description:
#   PagerDuty Integration for checking who's on call, making exceptions, ack, resolve, etc.
#
# Commands:
#
#   hubot who's on call - return the username of who's on call
#   hubot pager me page <msg> - create a new incident
#   hubot pager me 60 - take the pager for 60 minutes
#   hubot pager me incidents - return the current incidents
#   hubot pager me problems - return all open inicidents
#   hubot pager me ack 24 - ack incident #24
#   hubot pager me resolve 24 - resolve incident #24

# Configuration
#
#   HUBOT_PAGERDUTY_USERNAME
#   HUBOT_PAGERDUTY_PASSWORD
#   HUBOT_PAGERDUTY_SUBDOMAIN
#   HUBOT_PAGERDUTY_APIKEY     Service API Key from a 'General API Service'
#   HUBOT_PAGERDUTY_SCHEDULE_ID

pagerDutyUsers = {}
pagerDutyUsername    = process.env.HUBOT_PAGERDUTY_USERNAME
pagerDutyPassword    = process.env.HUBOT_PAGERDUTY_PASSWORD
pagerDutySubdomain   = process.env.HUBOT_PAGERDUTY_SUBDOMAIN
pagerDutyBaseUrl     = "https://#{pagerDutySubdomain}.pagerduty.com/api/v1"
pagerDutyApiKey      = process.env.HUBOT_PAGERDUTY_APIKEY

module.exports = (robot) ->
  robot.respond /pager( me)?$/i, (msg) ->

    cmds = robot.helpCommands()
    cmds = (cmd for cmd in cmds when cmd.match(/(pager me |who's on call)/))
    msg.send cmds.join("\n")

  # Assumes your Campfire usernames and PagerDuty names are identical
  robot.respond /pager( me)? (\d+)/i, (msg) ->
    withPagerDutyUsers msg, (users) ->
      username  = msg.message.user.name
      if username == "Shell"
        username = process.env.USER
      userId    = users[username].id
      now       = new Date()
      start     = now.toISOString()
      minutes   = parseInt msg.match[2]
      end       = now.addMinutes(minutes).toISOString()
      override  = {
        'start':     start,
        'end':       end,
        'user_id':   userId
      }
      withCurrentOncall msg, (old_username) ->
        data = { 'override': override }
        pagerDutyPost msg, "/schedules/#{process.env.HUBOT_PAGERDUTY_SCHEDULE_ID}/overrides", data, (json) ->
          if json.override
            msg.send "rejoice, #{old_username}! #{json.override.user.name} has the pager from #{json.override.start} until #{json.override.end}"

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
        msg.send "Chillin"

  robot.respond /(pager|major)( me)? page (.+)$/i, (msg) ->
    pagerDutyIntegrationAPI msg, "trigger", msg.match[3], (json) ->
      msg.reply "#{json.status}, key: #{json.incident_key}"

  robot.respond /(pager|major)( me)? ack(nowledge)? (.+)$/i, (msg) ->
    updateIncident(msg, msg.match[4], 'acknowledged')

  robot.respond /(pager|major)( me)? res(olve)?(d)? (.+)$/i, (msg) ->
    updateIncident(msg, msg.match[5], 'resolved')

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
  missingAnything


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
  now = new Date()
  oneHour = now.addHours(1).toISOString()
  now = now.toISOString()
  query = {
    since: now,
    until: oneHour,
    overflow: 'true'
  }
  pagerDutyGet msg, "/schedules/#{process.env.HUBOT_PAGERDUTY_SCHEDULE_ID}/entries", query, (json) ->
    if json.entries and json.entries.length > 0
      cb(json.entries[0].user.name)

withPagerDutyUsers = (msg, cb) ->
  if pagerDutyUsers['loaded'] != true
    pagerDutyGet msg, "/users", {}, (json) ->
      pagerDutyUsers['loaded'] = true
      for user in json.users
        pagerDutyUsers[user.id]   = user
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
