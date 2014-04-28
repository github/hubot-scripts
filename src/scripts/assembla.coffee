# Description:
#   Interact with assembla api
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ASSEMBLA_API_APP_ID - Create @ https://www.assembla.com/user/edit/manage_clients (leave website and redirect URLs blank)
#   HUBOT_ASSEMBLA_API_APP_SECRET
#   HUBOT_ASSEMBLA_SPACE - Assembla workspace that the script will interact with
#   HUBOT_ASSEMBLA_DEPLOY_ACTION_ID - SSH action id for your default deploy
#
# Commands:
#   hubot deploy - deploy the default project [assembla]
#   hubot deploy #<merge_req_number> - merge and close an MR then perform deploy via ssh_tool [assembla]
#   hubot sshtool actions - list actions in the ssh tool [assembla]
#   hubot sshtool action <ssh_tool_action_id_or_name> - look up a sshtool action by id or name [assembla]
#   hubot sshtool run <ssh_tool_action_id_or_name> - run a sshtool action by id or name [assembla]
#   hubot assembla pin <pin_code> - authenticate with a pin code [assembla]
#   hubot forget my assembla auth - forget api token [assembla]
#   hubot assembla whoami - who are you on assembla [assembla]
#   hubot mr #<merge request> - show merge request [assembla]
#   hubot merge request #<merge request> - show merge request [assembla]
#   hubot merge_and_close merge request #<merge request> - merge and close merge request [assembla]
#   hubot ignore merge request #<merge request> - ignore merge request [assembla]
#   hubot create ticket <summary> - Creates a ticket on default space [assembla]
#   hubot create ticket <summary> #in <space> - create a ticket on the space given [assembla]
#   hubot assembla user <username_or_id> - display user [assembla]
#   hubot space <space> - look up a space by id or wiki_name [assembla]
#   ticket #<ticket> - show ticket on default space [assembla]
#

SPACE = process.env.HUBOT_ASSEMBLA_SPACE
SSH_DEPLOY_ACTION_ID = process.env.HUBOT_ASSEMBLA_DEPLOY_ACTION_ID

api_app_id = process.env.HUBOT_ASSEMBLA_API_APP_ID
api_app_secret = process.env.HUBOT_ASSEMBLA_API_APP_SECRET

api_call = (msg, call, cb, params="", action="get", data_body="") ->
  user_id = msg.envelope.user.id
  refresh_token = msg.robot.brain.data.users[user_id].assembla_refresh_token
  msg.robot.http("https://#{api_app_id}:#{api_app_secret}@api.assembla.com/token?grant_type=refresh_token&refresh_token=#{refresh_token}")
    .header('accept', 'application/json')
    .header('User-Agent', "Hubot/#{@version}")
    .post('') (err, res, body) ->
      response = JSON.parse(body)
      if response.error == "invalid_grant"
        msg.send "Looks like you need to authenticate. Please generate a PIN code here: https://api.assembla.com/authorization?client_id=#{api_app_id}&response_type=pin_code"
        msg.send "Then, tell me your pin. \"#{msg.robot.name} assembla pin <your_pin_here>\""
      else
        access_token = response['access_token']
        switch action
          when 'get'
            msg.robot.http("https://api.assembla.com/v1/#{call}.json?#{params}")
              .header('accept', 'application/json')
              .header('Authorization', "Bearer #{access_token}")
              .header('User-Agent', "Hubot/#{@version}")
              .get() (err, res, body) ->
                response = JSON.parse(body)
                cb response
          when 'delete'
            msg.robot.http("https://api.assembla.com/v1/#{call}.json?#{params}")
              .header('accept', 'application/json')
              .header('Authorization', "Bearer #{access_token}")
              .header('User-Agent', "Hubot/#{@version}")
              .delete() (err, res, body) ->
                response = JSON.parse(body)
                cb response
          when 'post'
            msg.robot.http("https://api.assembla.com/v1/#{call}.json")
              .header('accept', 'application/json')
              .header('Authorization', "Bearer #{access_token}")
              .header('User-Agent', "Hubot/#{@version}")
              .post(data_body) (err, res, body) ->
                if body != " "
                  response = JSON.parse(body)
                cb response
          when 'put'
            msg.robot.http("https://api.assembla.com/v1/#{call}.json?#{params}")
              .header('accept', 'application/json')
              .header('Authorization', "Bearer #{access_token}")
              .header('User-Agent', "Hubot/#{@version}")
              .put(data_body) (err, res, body) ->
                if body != ""
                  response = JSON.parse(body)
                cb response

find_space_tool_for_mr = (msg, id, space, st_cb) ->
  api_call msg, "spaces/#{space}/space_tools/repo", (data) ->
    if data
      space_tool_ids = (space_tool_id['id'] for space_tool_id in data)
      for space_tool_id in space_tool_ids
        do (msg, space, space_tool_id, st_cb, id) ->
          api_call msg, "spaces/#{space}/space_tools/#{space_tool_id}/merge_requests/#{id}", (data) ->
            unless data['id'] == undefined
              st_cb space_tool_id

assembla_whoami = (msg, cb) ->
  api_call msg, "user", (data) ->
    cb data['login']

report_when_last_action_complete = (msg, action_id, last_id, robot, is_deploy = false) ->
  task = if is_deploy then "Deploy" else "Action"
  api_call msg, "spaces/#{SPACE}/ssh/launches/#{last_id}/output", (data) ->
    if data['success'] == true
      msg.send "#{task} complete.\nfull output: https://www.assembla.com/spaces/#{SPACE}/ssh_tool/actions/#{action_id}/launches/#{last_id}"
    else
      setTimeout( () ->
          report_when_last_action_complete(msg, action_id, last_id, robot, is_deploy)
        1000)

merge_request_poller = (msg, space_tool_id, merge_request_id, robot) ->
  api_call msg, "spaces/#{SPACE}/space_tools/#{space_tool_id}/merge_requests/#{merge_request_id}", (mr_data) ->
    switch mr_data['status']
      when 2
        msg.send "Sorry, can't help you. MR #{merge_request_id} has IGNORED status"
      when 1
        msg.send "Merged. Continuing with deploy.."
        run_ssh_action msg, SSH_DEPLOY_ACTION_ID, robot, true
      when 0
        setTimeout( () ->
          merge_request_poller(msg, space_tool_id, merge_request_id, robot)
        1000)

get_ssh_actions = (msg, cb) ->
  api_call msg, "spaces/#{SPACE}/ssh/actions", (data) ->
    a = data.sort (a,b) ->
      return if a.position >= b.position then 1 else -1
    cb a

get_ssh_action = (msg, action, cb) ->
  get_ssh_actions msg, (actions) ->
    for a in actions
      do (a) ->
        if ( a['name'] == action || a['id'] == parseInt(action, 10) )
          cb a

run_ssh_action = (msg, action, robot, is_deploy = false) ->
  get_ssh_action msg, action, (data) ->
    id = data['id']
    api_call msg, "spaces/#{SPACE}/ssh/actions/#{id}/run", (data) ->
      if data
        task = if is_deploy then "Deploying" else "Executing ssh action \"#{data['name']}\""
        msg.send "#{task}.. monitor at: https://www.assembla.com/spaces/#{SPACE}/ssh_tool"
        api_call msg, "spaces/#{SPACE}/ssh/actions/#{id}/launches", (data) ->
          last = data[0]
          report_when_last_action_complete(msg, id, last.id, robot, is_deploy)
        , "page=1&per_page=1&sort_order=desc"


module.exports = (robot) ->

  robot.respond /assembla user (.*)/i, (msg) ->
    api_call msg, "users/#{msg.match[1]}", (data) ->
      if data['id'] == undefined
        msg.send "User not found"
      else
        if data['phone'] == undefined
          data['phone'] = ''
        msg.send "#{data['name']} - #{data['login']} - #{data['id']}\n#{data['email']} #{data['phone']}"

  robot.respond /(deploy$)/i, (msg) ->
    run_ssh_action msg, SSH_DEPLOY_ACTION_ID, robot, true

  robot.respond /deploy \#(\d+)$/i, (msg) ->
    id = msg.match[1]
    find_space_tool_for_mr msg, id, SPACE, (space_tool_id) ->
      unless space_tool_id == undefined
        api_call msg, "spaces/#{SPACE}/space_tools/#{space_tool_id}/merge_requests/#{id}/merge_and_close", (merge_data) ->
          if merge_data
            unless merge_data['error']
              msg.send "Submitted merge and close request for MR ##{id}"
              merge_request_poller(msg, space_tool_id, id, robot)
        , '', 'put'

  robot.respond /space (.*)/i, (msg) ->
    api_call msg, "spaces/#{msg.match[1].trim()}", (data) ->
      if data['id'] == undefined
        msg.send "Space not found"
      msg.send "#{data['name']} [#{data['id']}] #{data['description']}\nhttps://www.assembla.com/spaces/#{data['wiki_name']}"

  robot.hear /ticket \#(\d+)/i, (msg) ->
    api_call msg, "spaces/#{SPACE}/tickets/#{msg.match[1]}", (data) ->
      unless data['id'] == undefined
        msg.send "Ticket ##{data['number']}, #{data['summary']}\nhttps://www.assembla.com/spaces/#{SPACE}/tickets/#{data['number']}"

  robot.respond /create ticket((.*)#in(.*)|(.*))/i, (msg) ->
    if msg.match[2]
      summary = msg.match[2]
      space_name = msg.match[3].replace /^\s+|\s+$/g, ""
    else
      summary = msg.match[1]
      space_name = SPACE

    ticket_params = "ticket[summary]=#{summary}"
    api_call msg, "spaces/#{space_name}/tickets", (data) ->
      unless data['error']
        msg.send "Ticket Created"
        msg.send "https://www.assembla.com/spaces/#{space_name}/tickets/#{data['number']}"
      else
        msg.send "Error creating ticket"
        msg.send data['error']
    ,"", 'post', ticket_params

  robot.respond /assembla pin (\d+)/i, (msg) ->
    user_id = msg.envelope.user.id
    pin_code = msg.match[1].trim()
    robot.http("https://#{api_app_id}:#{api_app_secret}@api.assembla.com/token?grant_type=pin_code&pin_code=#{pin_code}")
      .header('accept', 'application/json')
      .header('User-Agent', "Hubot/#{@version}")
      .post('') (err, res, body) ->
        response = JSON.parse(body)
        refresh_token = response['refresh_token']
        robot.brain.data.users[user_id].assembla_refresh_token = refresh_token
        msg.send "Access token acquired and stored for user #{user_id}"

  robot.respond /forget (my )?(assembla )?auth/i, (msg) ->
    user_id = msg.envelope.user.id
    robot.brain.data.users[user_id].assembla_refresh_token = ''
    msg.send "Ok. I forgot."

  robot.respond /assembla whoami/i, (msg) ->
    assembla_whoami msg, (user_id) ->
      msg.send "#{user_id}"

  robot.respond /(mr|merge request) \#(\d+)$/i, (msg) ->
    id = msg.match[2]
    find_space_tool_for_mr msg, id, SPACE, (space_tool_id) ->
      unless space_tool_id == undefined
        api_call msg, "spaces/#{SPACE}/space_tools/#{space_tool_id}/merge_requests/#{id}", (mr_data) ->
          switch mr_data['status']
            when 0 then status = 'OPEN'
            when 1 then status = 'MERGED'
            when 2 then status = 'IGNORED'
          api_call msg, "users/#{mr_data['user_id']}", (userdata) ->
            unless userdata['name'] == undefined
              msg.send "MR ##{mr_data['id']} [#{status}], owner: #{userdata['name']}, #{mr_data['title']}\nhttps://www.assembla.com/code/#{SPACE}/git/merge_requests/#{id}"

  robot.respond /ignore (mr|merge request) \#(\d+)$/i, (msg) ->
    id = msg.match[2]
    find_space_tool_for_mr msg, id, SPACE, (space_tool_id) ->
      unless space_tool_id == undefined
        api_call msg, "spaces/#{SPACE}/space_tools/#{space_tool_id}/merge_requests/#{id}/ignore", (merge_data) ->
          unless merge_data['error']
            msg.send "Ignored merge request ##{id}"
        , '', 'put'

  robot.respond /(merge|merge_and_close) (mr|merge request) \#(\d+)$/i, (msg) ->
    id = msg.match[3]
    find_space_tool_for_mr msg, id, SPACE, (space_tool_id) ->
      unless space_tool_id == undefined
        api_call msg, "spaces/#{SPACE}/space_tools/#{space_tool_id}/merge_requests/#{id}/merge_and_close", (merge_data) ->
          unless merge_data['error']
            msg.send "Submitted merge and close request for MR ##{id}"
        , '', 'put'

  robot.respond /sshtool (actions|list)/i,(msg) ->
    get_ssh_actions msg, (actions) ->
      output = "SSH Actions for space #{SPACE}"
      for a in actions
        do (a) ->
          output += "\n\'#{a['name']}\' (#{a['description']}), id: #{a['id']}"
      msg.send output

  robot.respond /sshtool action [\'\"]?(.*)[\'\"]?$/i, (msg) ->
    action = msg.match[1].trim()
    get_ssh_action msg, action, (data) ->
      a = data
      msg.send "\'#{a['name']}\' (#{a['description']}), id: #{a['id']}"
      msg.send "command: \'#{a['command']}\'"

  robot.respond /sshtool run [\'\"]?(.*)[\'\"]?$/i, (msg) ->
    action = msg.match[1].trim()
    run_ssh_action msg, action, robot

