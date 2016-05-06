# Description:
#   A way to add tasks to Asana
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ASANA_API_KEY - find this in Account Settings -> API
#
#   HUBOT_ASANA_WORKSPACE_ID - list all workspaces using
#   curl -u <api_key>: https://app.asana.com/api/1.0/workspaces
#   (note the colon after the api key)
#
#   HUBOT_ASANA_PROJECT_ID - list all projects in the workspace using:
#   curl -u <api_key>: https://app.asana.com/api/1.0/workspaces/<workspace id>/projects
#
# Commands:
#   todo: @name? <task directive> - public message starting with todo: will add task, optional @name to assign task
#   hubot todo users - Message the bot directly to list all available users in the workspace
#
# Author:
#   idpro
#   abh1nav
#   rajiv

url  = 'https://app.asana.com/api/1.0'

workspace = process.env.HUBOT_ASANA_WORKSPACE_ID
project = process.env.HUBOT_ASANA_PROJECT_ID
api_key = process.env.HUBOT_ASANA_API_KEY

getRequest = (msg, path, callback) ->
  msg.http("#{url}#{path}")
    .headers("Accept": "application/json")
    .auth(api_key, '')
    .get() (err, res, body) ->
      callback(err, res, body)

postRequest = (msg, path, params, callback) ->
  stringParams = JSON.stringify params
  msg.http("#{url}#{path}")
    .headers("Content-Length": stringParams.length, "Accept": "application/json")
    .auth(api_key, '')
    .post(stringParams) (err, res, body) ->
      callback(err, res, body)

addTask = (msg, taskName, path, params, userAcct) ->
  postRequest msg, '/tasks', params, (err, res, body) ->
    response = JSON.parse body
    if response.data.errors
      msg.send response.data.errors
    else
      projectId = response.data.id
      params = {data:{project: "#{project}"}}
      postRequest msg, "/tasks/#{projectId}/addProject", params, (err, res, body) ->
        response = JSON.parse body
        if response.data
          if userAcct
            msg.send "Task Created : #{taskName} : Assigned to @#{userAcct}"
          else
            msg.send "Task Created : #{taskName}"
        else
          msg.send "Error creating task."

module.exports = (robot) ->
# Add a task
  robot.hear /^(todo|task):\s?(@\w+)?(.*)/i, (msg) ->
    taskName = msg.match[3]
    userAcct = msg.match[2] if msg.match[2] != undefined
    params = {data:{name: "#{taskName}", workspace: "#{workspace}"}}
    if userAcct
      userAcct = userAcct.replace /^\s+|\s+$/g, ""
      userAcct = userAcct.replace "@", ""
      userAcct = userAcct.toLowerCase()
      getRequest msg, "/workspaces/#{workspace}/users", (err, res, body) ->
        response = JSON.parse body
        assignedUser = ""
        for user in response.data
          name = user.name.toLowerCase().split " "
          if userAcct == name[0] || userAcct == name[1]
            assignedUser = user.id
        if assignedUser != ""
          params = {data:{name: "#{taskName}", workspace: "#{workspace}", assignee: "#{assignedUser}"}}
          addTask msg, taskName, '/tasks', params, userAcct
        else
          msg.send "Unable to Assign User"
          addTask msg, taskName, '/tasks', params, false
    else
      addTask msg, taskName, '/tasks', params, false

# show task title
  robot.hear /https:\/\/app\.asana\.com\/(\d+)\/(\d+)\/(\d+)/, (msg) ->
    taskId = msg.match[3]
    getRequest msg, "/tasks/#{taskId}", (err, res, body) ->
      response = JSON.parse body
      name = response.data.name
      msg.send "#{taskId}: #{name}"

# List all Users
  robot.respond /(todo users)/i, (msg) ->
    getRequest msg, "/workspaces/#{workspace}/users", (err, res, body) ->
      response = JSON.parse body
      userList = ""
      for user in response.data
        userList += "#{user.id} : #{user.name}\n"

      msg.send userList
