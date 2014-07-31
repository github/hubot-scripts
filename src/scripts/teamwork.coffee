# Description
#   Complete a task in teamworkpm
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TEAMWORK_API_KEY
#   HUBOT_TEAMWORK_URL
#
# Commands:
#   hubot complete task <id> - completes the task and confirms the status
#
# Author:
#   ready4god2513
module.exports = (robot) ->
  robot.respond /complete task ([0-9]+)/i, (msg) ->
    id = msg.match[1]
    user = process.env.HUBOT_TEAMWORK_API_KEY
    teamwork_url = process.env.HUBOT_TEAMWORK_URL

    unless user
      msg.send "The HUBOT_TEAMWORK_API_KEY must be provided in order to complete teamwork tasks"
      return

    unless teamwork_url
      msg.send "The HUBOT_TEAMWORK_URL must be provided in order to complete teamwork tasks"
      return

    auth = 'BASIC ' + new Buffer("#{user}:xxx").toString('base64');
    url = "#{teamwork_url}/tasks/#{id}/complete.json"

    msg.http(url)
      .headers(Authorization: auth)
      .put() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "Great!  Task #{id} was marked complete"
          when 401
            msg.send "
              Your authentication credentials were denied.  
              Please check your HUBOT_TEAMWORK_API_KEY and HUBOT_TEAMWORK_URL
              "
          else
            msg.send body