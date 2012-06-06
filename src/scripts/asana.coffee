# A way to add tasks to Asana
#
# todo: @name? <task directive> - public message starting with todo: will
#                                 add task, optional @name to assign task
# @bot todo users               - Message the bot directly to list all 
#                                 available users in the workspace
# 
# Written by @idPro


url  = 'https://app.asana.com/api/1.0'

workspace = "WORKSPACE_ID"
project = "PROJECT_ID"
user = "xxxxx.xxxxxxxxxxxxxxx"
pass = ""

getRequest = (msg, path, callback) ->
  auth = 'Basic ' + new Buffer("#{user}:#{pass}").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)

postRequest = (msg, path, params, callback) ->
  stringParams = JSON.stringify params
  auth = 'Basic ' + new Buffer("#{user}:#{pass}").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Content-Length": stringParams.length, "Accept": "application/json")
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

# List all Users
  robot.respond /(todo users)/i, (msg) ->
    getRequest msg, "/workspaces/#{workspace}/users", (err, res, body) ->
      response = JSON.parse body
      userList = ""
      for user in response.data
        userList += "#{user.id} : #{user.name}\n"

      msg.send userList