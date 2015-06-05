# Description:
#   PagerDuty integration for checking who's on call, making exceptions, ack, resolve, etc.
#
# Commands:
#
#   hubot who's on call - return the username of who's on call
#   hubot pager me trigger <msg> - create a new incident with <msg>
#   hubot pager me 60 - take the pager for 60 minutes
#   hubot pager me as <email> - remember your pager email is <email>
#   hubot pager me incidents - return the current incidents
#   hubot pager me incident NNN - return the incident NNN
#   hubot pager me note <incident> <content> - add note to incident #<incident> with <content>
#   hubot pager me notes <incident> - show notes for incident #<incident>
#   hubot pager me problems - return all open incidents
#   hubot pager me ack <incident> - ack incident #<incident>
#   hubot pager me ack <incident1> <incident2> ... <incidentN> - ack all specified incidents
#   hubot pager me ack - ack all triggered incidents 
#   hubot pager me resolve <incident> - resolve incident #<incident>
#   hubot pager me resolve <incident1> <incident2> ... <incidentN>- resolve all specified incidents
#   hubot pager me resolve - resolve all acknowledged incidents
#
# Dependencies:
#  "moment": "1.6.2"
#
# Notes: 
#   To setup the webhooks and get the alerts in your chatrooms, you need to add the endpoint you define here (e.g /hooks) in 
#   the service settings of your PagerDuty accounts. You also need to define the room in which you want them to appear. 
#   (Unless you want to spam all the rooms with alerts, but we don't believe that should be the default behavior :)  
#
# URLs: 
#   http://developer.pagerduty.com/documentation/rest/webhooks
#   http://support.pagerduty.com/entries/21774694-Webhooks-
#
# Configuration:
#
#   HUBOT_PAGERDUTY_API_KEY - API Access Key
#   HUBOT_PAGERDUTY_SUBDOMAIN
#   HUBOT_PAGERDUTY_SERVICE_API_KEY - Service API Key from a 'General API Service'
#   HUBOT_PAGERDUTY_SCHEDULE_ID
#   HUBOT_PAGERDUTY_ROOM - Room in which you want the PagerDuty webhook notifications to appear
#   HUBOT_PAGERDUTY_ENDPOINT - PagerDuty webhook listener e.g /hook
#
# Authors: 
#   Jesse Newland, Josh Nicols, Jacob Bednarz, Chris Lundquist, Chris Streeter, Joseph Pierri, Greg Hoin
#

inspect = require('util').inspect

moment = require('moment')

pagerDutyApiKey        = process.env.HUBOT_PAGERDUTY_API_KEY
pagerDutySubdomain     = process.env.HUBOT_PAGERDUTY_SUBDOMAIN
pagerDutyBaseUrl       = "https://#{pagerDutySubdomain}.pagerduty.com/api/v1"
pagerDutyServiceApiKey = process.env.HUBOT_PAGERDUTY_SERVICE_API_KEY
pagerDutyScheduleId    = process.env.HUBOT_PAGERDUTY_SCHEDULE_ID
pagerRoom              = process.env.HUBOT_PAGERDUTY_ROOM
# Webhook listener endpoint. Set it to whatever URL you want, and make sure it matches your pagerduty service settings 
pagerEndpoint          = process.env.HUBOT_PAGERDUTY_ENDPOINT || "/hook"

module.exports = (robot) ->
  robot.logger.warning "pagerduty.coffee has moved from hubot-scripts to its own package. See https://github.com/hubot-scripts/hubot-pager-me installation instructions"

  robot.respond /pager( me)?$/i, (msg) ->
    if missingEnvironmentForApi(msg)
      return


    withPagerDutyUser msg, (user) ->
      emailNote = if msg.message.user.pagerdutyEmail
                    "You've told me your PagerDuty email is #{msg.message.user.pagerdutyEmail}"
                  else if msg.message.user.email_address
                    "I'm assuming your PagerDuty email is #{msg.message.user.email_address}. Change it with `#{robot.name} pager me as you@yourdomain.com`"
      if user
        msg.send "I found your PagerDuty user https://#{pagerDutySubdomain}.pagerduty.com#{user.user_url}, #{emailNote}"
      else
        msg.send "I couldn't find your user :( #{emailNote}"



    cmds = robot.helpCommands()
    cmds = (cmd for cmd in cmds when cmd.match(/(pager me |who's on call)/))
    msg.send cmds.join("\n")

  robot.respond /pager(?: me)? as (.*)$/i, (msg) ->
    email = msg.match[1]
    msg.message.user.pagerdutyEmail = email
    msg.send "Okay, I'll remember your PagerDuty email is #{email}"

  # Assumes your Campfire usernames and PagerDuty names are identical
  robot.respond /pager( me)? (\d+)/i, (msg) ->
    withPagerDutyUser msg, (user) ->

      userId = user.id
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
            msg.send "Rejoice, #{old_username}! #{json.override.user.name} has the pager until #{end.format()}"

  robot.respond /(pager|major)( me)? incident (.*)$/, (msg) ->
    pagerDutyIncident msg, msg.match[3], (incident) ->
      msg.send formatIncident(incident)

  robot.respond /(pager|major)( me)? (inc|incidents|sup|problems)$/i, (msg) ->
    pagerDutyIncidents msg, "triggered,acknowledged", (incidents) ->
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

  robot.respond /(pager|major)( me)? (?:trigger|page) (.+)$/i, (msg) ->
    user = msg.message.user.name
    reason = msg.match[3]

    description = "#{reason} - @#{user}"
    pagerDutyIntegrationAPI msg, "trigger", description, (json) ->
      msg.reply "#{json.status}, key: #{json.incident_key}"

  robot.respond /(?:pager|major)(?: me)? ack(?:nowledge)? (.+)$/i, (msg) ->
    incidentNumbers = parseIncidentNumbers(msg.match[1])

    # only acknowledge triggered things, since it doesn't make sense to re-acknowledge if it's already in re-acknowledge
    # if it ever doesn't need acknowledge again, it means it's timed out and has become 'triggered' again anyways
    updateIncidents(msg, incidentNumbers, 'triggered,acknowledged', 'acknowledged')

  robot.respond /(pager|major)( me)? ack(nowledge)?$/i, (msg) ->
    pagerDutyIncidents msg, 'triggered,acknwowledged', (incidents) ->
      incidentNumbers = (incident.incident_number for incident in incidents)
      if incidentNumbers.length < 1
        msg.send "Nothing to acknowledge"
        return

      # only acknowledge triggered things
      updateIncidents(msg, incidentNumbers, 'triggered,acknowledged', 'acknowledged')

  robot.respond /(?:pager|major)(?: me)? res(?:olve)?(?:d)? (.+)$/i, (msg) ->
    incidentNumbers = parseIncidentNumbers(msg.match[1])

    # allow resolving of triggered and acknowedlge, since being explicit
    updateIncidents(msg, incidentNumbers, 'triggered,acknowledged', 'resolved')

  robot.respond /(pager|major)( me)? res(olve)?(d)?$/i, (msg) ->
    pagerDutyIncidents msg, "acknowledged", (incidents) ->
      incidentNumbers = (incident.incident_number for incident in incidents)
      if incidentNumbers.length < 1
        msg.send "Nothing to resolve"
        return

      # only resolve things that are acknowledged 
      updateIncidents(msg, incidentNumbers, 'acknowledged', 'resolved')

  robot.respond /(pager|major)( me)? notes (.+)$/i, (msg) ->
    incidentId = msg.match[3]
    pagerDutyGet msg, "/incidents/#{incidentId}/notes", {}, (json) ->
      buffer = ""
      for note in json.notes
        buffer += "#{note.created_at} #{note.user.name}: #{note.content}\n"
      msg.send buffer


  robot.respond /(pager|major)( me)? note ([\d\w]+) (.+)$/i, (msg) ->
    incidentId = msg.match[3]
    content = msg.match[4]

    withPagerDutyUser msg, (user) ->
      userId = user.id
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

  parseIncidentNumbers = (match) ->
    match.split(/[ ,]+/).map (incidentNumber) ->
      parseInt(incidentNumber)

  missingEnvironmentForApi = (msg) ->
    missingAnything = false
    unless pagerDutySubdomain?
      msg.send "PagerDuty Subdomain is missing:  Ensure that HUBOT_PAGERDUTY_SUBDOMAIN is set."
      missingAnything |= true
    unless pagerDutyApiKey?
      msg.send "PagerDuty API Key is missing:  Ensure that HUBOT_PAGERDUTY_API_KEY is set."
      missingAnything |= true
    unless pagerDutyScheduleId?
      msg.send "PagerDuty Schedule ID is missing:  Ensure that HUBOT_PAGERDUTY_SCHEDULE_ID is set."
      missingAnything |= true
    missingAnything


  withPagerDutyUser = (msg, cb) ->

    email  = msg.message.user.pagerdutyEmail || msg.message.user.email_address
    unless email
      msg.send "Sorry, I can't figure out your email address :( Can you tell me with `#{robot.name} pager me as you@yourdomain.com`?"
      return

    pagerDutyGet msg, "/users", {query: email}, (json) ->
      if json.users.length isnt 1
        msg.send "Sorry, I expected to get 1 user back for #{email}, but got #{json.users.length} :sweat:"
        return

      cb(json.users[0])


  pagerDutyGet = (msg, url, query, cb) ->
    if missingEnvironmentForApi(msg)
      return

    auth = "Token token=#{pagerDutyApiKey}"
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
    auth = "Token token=#{pagerDutyApiKey}"
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
    auth = "Token token=#{pagerDutyApiKey}"
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

  pagerDutyIncident = (msg, incident, cb) ->
    pagerDutyGet msg, "/incidents/#{encodeURIComponent incident}", {}, (json) ->
      cb(json)

  pagerDutyIncidents = (msg, status, cb) ->
    query =
      status:  status
      sort_by: "incident_number:asc"
    pagerDutyGet msg, "/incidents", query, (json) ->
      cb(json.incidents)

  pagerDutyIntegrationAPI = (msg, cmd, description, cb) ->
    unless pagerDutyServiceApiKey?
      msg.send "PagerDuty API service key is missing."
      msg.send "Ensure that HUBOT_PAGERDUTY_SERVICE_API_KEY is set."
      return

    data = null
    switch cmd
      when "trigger"
        data = JSON.stringify { service_key: pagerDutyServiceApiKey, event_type: "trigger", description: description}
        pagerDutyIntergrationPost msg, data, (json) ->
          cb(json)

  formatIncident = (inc) ->
     # { pd_nagios_object: 'service',
     #   HOSTNAME: 'fs1a',
     #   SERVICEDESC: 'snapshot_repositories',
     #   SERVICESTATE: 'CRITICAL',
     #   HOSTSTATE: 'UP' },
    
    summary = if inc.trigger_summary_data
              # email services
              if inc.trigger_summary_data.subject
                inc.trigger_summary_data.subject
              else if inc.trigger_summary_data.description
                inc.trigger_summary_data.description
              else if inc.trigger_summary_data.pd_nagios_object == 'service'
                 "#{inc.trigger_summary_data.HOSTNAME}/#{inc.trigger_summary_data.SERVICEDESC}"
              else if inc.trigger_summary_data.pd_nagios_object == 'host'
                 "#{inc.trigger_summary_data.HOSTNAME}/#{inc.trigger_summary_data.HOSTSTATE}"
              else
                ""
            else
              ""
    assigned_to = if inc.assigned_to_user
                    "- assigned to #{inc.assigned_to_user.name}"
                  else
                    ""
                    

    "#{inc.incident_number}: #{inc.created_on} #{summary} #{assigned_to}\n"

  updateIncidents = (msg, incidentNumbers, statusFilter, updatedStatus) ->
    withPagerDutyUser msg, (user) ->

      requesterId = user.id
      return unless requesterId

      pagerDutyIncidents msg, statusFilter, (incidents) ->
        foundIncidents = []
        for incident in incidents
          # FIXME this isn't working very consistently
          if incidentNumbers.indexOf(incident.incident_number) > -1
            foundIncidents.push(incident)

        if foundIncidents.length == 0
          msg.reply "Couldn't find incidents #{incidentNumbers.join(', ')} in #{inspect incidents}"
        else
          # loljson
          data = {
            requester_id: requesterId
            incidents: foundIncidents.map (incident) ->
              {
                'id':     incident.id,
                'status': updatedStatus
              }
          }

          pagerDutyPut msg, "/incidents", data , (json) ->
            if json?.incidents
              buffer = "Incident"
              buffer += "s" if json.incidents.length > 1
              buffer += " "
              buffer += (incident.incident_number for incident in json.incidents).join(", ")
              buffer += " #{updatedStatus}"
              msg.reply buffer
            else
              msg.reply "Problem updating incidents #{incidentNumbers.join(',')}"


  pagerDutyIntergrationPost = (msg, json, cb) ->
    msg.http('https://events.pagerduty.com/generic/2010-04-15/create_event.json')
      .header("content-type","application/json")
      .header("content-length", json.length)
      .post(json) (err, res, body) ->
        switch res.statusCode
          when 200
            json = JSON.parse(body)
            cb(json)
          else
            console.log res.statusCode
            console.log body

  
  # Pagerduty Webhook Integration (For a payload example, see http://developer.pagerduty.com/documentation/rest/webhooks)
  parseWebhook = (req, res) ->
    hook = req.body

    messages = hook.messages

    if /^incident.*$/.test(messages[0].type)
      parseIncidents(messages)
    else
      "No incidents in webhook"

  getUserForIncident = (incident) ->
    if incident.assigned_to_user
      incident.assigned_to_user.email
    else if incident.resolved_by_user
      incident.resolved_by_user.email
    else
      '(???)'

  generateIncidentString = (incident, hookType) ->
    console.log "hookType is " + hookType
    if hookType == "incident.trigger"
      """
      Incident # #{incident.incident_number} :
      #{incident.status} and assigned to #{getUserForIncident(incident)}
       #{incident.html_url}
      To acknowledge: @#{robot.name} pager me ack #{incident.incident_number}
       To resolve: @#{robot.name} pager me resolve #{incident.incident_number}
      """
    else if hookType == "incident.acknowledge"
      """
      Incident # #{incident.incident_number} :
      #{incident.status} and assigned to #{getUserForIncident(incident)}
       #{incident.html_url}
      To resolve: @#{robot.name} pager me resolve #{incident.incident_number}
      """
    else if hookType == "incident.resolve"
      """
      Incident # #{incident.incident_number} has been resolved by #{getUserForIncident(incident)}
       #{incident.html_url}
      """
    else if hookType == "incident.unacknowledge"
      """
      #{incident.status} , unacknowledged and assigned to #{getUserForIncident(incident)}
       #{incident.html_url}
      To acknowledge: @#{robot.name} pager me ack #{incident.incident_number}
       To resolve: @#{robot.name} pager me resolve #{incident.incident_number}
      """
    else if hookType == "incident.assign"
      """
      Incident # #{incident.incident_number} :
      #{incident.status} , reassigned to #{getUserForIncident(incident)}
       #{incident.html_url}
      To resolve: @#{robot.name} pager me resolve #{incident.incident_number}
      """
    else if hookType == "incident.escalate"
      """
      Incident # #{incident.incident_number} :
      #{incident.status} , was escalated and assigned to #{getUserForIncident(incident)}
       #{incident.html_url}
      To acknowledge: @#{robot.name} pager me ack #{incident.incident_number}
       To resolve: @#{robot.name} pager me resolve #{incident.incident_number}
      """

  parseIncidents = (messages) ->
    returnMessage = []
    count = 0
    for message in messages
      incident = message.data.incident
      hookType = message.type
      returnMessage.push(generateIncidentString(incident, hookType))
      count = count+1
    returnMessage.unshift("You have " + count + " PagerDuty update(s): \n")
    returnMessage.join("\n")


  # Webhook listener
  if pagerEndpoint && pagerRoom
    robot.router.post pagerEndpoint, (req, res) ->
      robot.messageRoom(pagerRoom, parseWebhook(req,res))
      res.end()
