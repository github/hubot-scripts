# Description:
#   Listens for Trajectory story and idea links.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TRAJECTORY_APIKEY: your Trajectory API key
#   HUBOT_TRAJECTORY_ACCOUNT: your Trajectory account number
#
# Commands:
#   <a Trajectory story or idea URL> - sends back some details
#
# Author:
#   galfert

module.exports = (robot) ->
  robot.hear /apptrajectory\.com\/\w+\/(\w+)\/(stories|ideas)\/(\d+)/i, (msg) ->
    apiKey  = process.env.HUBOT_TRAJECTORY_APIKEY
    account = process.env.HUBOT_TRAJECTORY_ACCOUNT

    unless apiKey && account
      msg.send "Please set HUBOT_TRAJECTORY_APIKEY and HUBOT_TRAJECTORY_ACCOUNT correctly"
      return

    project     = msg.match[1]
    elementType = msg.match[2]
    elementId   = parseInt msg.match[3], 10

    baseURL = "https://www.apptrajectory.com/api/#{apiKey}/accounts/#{account}/projects/#{project}"
    detailsURL = {
      "stories": "#{baseURL}/stories/#{elementId}.json",
      "ideas"  : "#{baseURL}/ideas.json"
    }[elementType]

    msg.http(detailsURL).get() (err, res, body) ->
      if err
        msg.send "Trajectory says: #{err}"
        return
      unless res.statusCode is 200
        msg.send "Got me a code #{res.statusCode}"
        return

      details = JSON.parse body

      if elementType == 'stories'
        message = "\"#{details.title}\""
        message += ", assigned to #{details.assignee_name}" if details.assignee_name
        message += " (#{details.state} #{details.task_type.toLowerCase()})"
        msg.send message

      else if elementType == 'ideas'
        for idea in details
          if idea.id == elementId
            message = "\"#{idea.subject}\""
            message += ", created by #{idea.user.name}" if idea.user
            message += " (#{idea.state})"
            msg.send message
            return
        msg.send "I've got no idea what you are talking about"
