# Description:
#   Some interaction with basecamp
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BASECAMP_KEY
#   HUBOT_BASECAMP_URL
#
# Commands:
#
# Author:
#   fellix

module.exports = (robot) ->
  robot.hear /^basecamp calendar( (.*))?$/i, (msg) ->
    project_name = msg.match[2]
    basecamp_request msg, 'projects.json', (projects) ->
      for project in projects.records
        if project_name 
          if project.name == project_name
            print_calendar msg, project, true
            return
        else
          print_calendar msg, project, false
          
print_calendar = (msg, project, searching) ->
  basecamp_request msg, "projects/#{project.id}/milestones.json", (entries) ->
    if entries.count <= 0
      msg.send "No milestone found in this project #{project.name}" if searching
      return
    for milestone in entries.records
      unless milestone.completedOn
        responsability = "None"
        responsability = milestone.responsibleParty.name if milestone.responsibleParty
        msg.send "[#{project.name}] #{milestone.title} -> #{milestone.status}: #{milestone.deadline}, Responsible: #{responsability}"
          
basecamp_request = (msg, url, handler) ->
  basecamp_key = "#{process.env.HUBOT_BASECAMP_KEY}"
  auth = new Buffer("#{basecamp_key}:X").toString('base64')
  basecamp_url = "https://#{process.env.HUBOT_BASECAMP_URL}.basecamphq.com"
  msg.http("#{basecamp_url}/#{url}")
    .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Basecamp says: #{err}"
          return
        content = JSON.parse(body)
        handler content
