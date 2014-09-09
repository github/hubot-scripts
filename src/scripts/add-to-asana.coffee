# Description:
#   Add tasks to Asana.
#
# Dependencies:
#   None
#
# Configuration:
#   ASANA_WORKSPACE_ID
#   ASANA_TEAM_ID
#   ASANA_DEFAULT_PROJECT_ID
#   ASANA_DEFAULT_PROJECT_NAME
#
# Commands:
#   asana: @<name> <task name> #<project> -- Add task to asana with optional @assignee and #project.
#
# Author:
#   gumroad

url  = 'https://app.asana.com/api/1.0'

workspace_id = process.env.ASANA_WORKSPACE_ID
team_id = process.env.ASANA_TEAM_ID
default_project_id = process.env.ASANA_DEFAULT_PROJECT_ID
default_project_name = process.env.ASANA_DEFAULT_PROJECT_NAME

postRequest = (msg, path, api_key, params, callback) ->
  stringParams = JSON.stringify params
  auth = 'Basic ' + new Buffer("#{api_key}:").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json"
           , "Content-Length": stringParams.length)
    .post(stringParams) (err, res, body) ->
      callback(err, res, body)

getRequest = (msg, path, api_key, callback) ->
  auth = 'Basic ' + new Buffer("#{api_key}:").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)

addTask = (msg, api_key, params) ->
  postRequest msg, '/tasks', api_key, params, (err, res, body) ->
    response = JSON.parse body

    if response.data
      msg.send "Added to #{response.data.projects[0].name}: https://app.asana.com/0/#{response.data.projects[0].id}/#{response.data.id}"
    else
      msg.send "Error adding task: " + body + "."

getAssignee = (msg, api_key, assignee_name, callback) ->
  return callback({success: false}) if assignee_name == undefined
  assignee_name = assignee_name.replace "@", ""
  getRequest msg, '/users', api_key, (err, res, body) ->
    response = JSON.parse body
    for user in response.data
      pattern = new RegExp(assignee_name, 'i')
      if pattern.test(user.name)
        return callback({success: true, assignee_id: user.id})
    callback({success: false})

getProject = (msg, api_key, project_name, callback) ->
  return callback({success: false}) if project_name == undefined
  project_name = project_name.replace "#", ""
  project_name = project_name.replace "-", " "
  matched_project_id = undefined
  getRequest msg, '/projects?archived=false', api_key, (err, res, body) ->
    response = JSON.parse body
    matches = 0
    for project in response.data
      pattern = new RegExp(project_name, 'i')
      if pattern.test(project.name)
        matched_project_id = project.id
        matches++
    if matches == 1
      return callback({success: true, project_id: matched_project_id})
    if matches > 1
      msg.send "Too many projects match, adding to #{default_project_name}. Please move it to the project you meant."
    callback({success: false})

module.exports = (robot) ->
  robot.respond /asana: (.*)$/i, (msg) ->
    robot.brain.set("asana_api_key_#{msg.message.user.name}", msg.match[1])
    msg.send "You should be good to add Asana tasks now!"

  robot.hear /^asana:\s?(@\w+)? ([^#]*)\s?(#[\w-]+)?/i, (msg) ->
    api_key = robot.brain.get("asana_api_key_#{msg.message.user.name}")
    if api_key
      assignee_name = msg.match[1]
      task_name = msg.match[2].trim()
      project_name = msg.match[3]

      params = {
        data: {
          name: task_name,
          workspace: workspace_id,
          team: team_id,
          projects: [default_project_id]
        }
      }

      getAssignee msg, api_key, assignee_name, (data) ->
        if data.success
          params.data.assignee = data.assignee_id

        getProject msg, api_key, project_name, (data) ->
          if data.success
            params.data.projects = [data.project_id]

          addTask msg, api_key, params
    else
      msg.send "I need your Asana API key (click your name on the bottom left, then Apps). Send it to me in a 1-1 like this: 'asana: Zfxdag4s...'"