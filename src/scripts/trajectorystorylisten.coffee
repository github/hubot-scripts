# Listens for Trajectory story links.
#
# paste a Trajectory story URL - sends back some story details
#
# You need to set the following variables:
#   HUBOT_TRAJECTORY_APIKEY: your Trajectory API key
#   HUBOT_TRAJECTORY_ACCOUNT: your Trajectory account number
#
module.exports = (robot) ->
  robot.hear /apptrajectory\.com\/\w+\/(\w+)\/stories\/(\d+)/i, (msg) ->
    apiKey  = process.env.HUBOT_TRAJECTORY_APIKEY
    account = process.env.HUBOT_TRAJECTORY_ACCOUNT

    unless apiKey && account
      msg.send "Please set HUBOT_TRAJECTORY_APIKEY and HUBOT_TRAJECTORY_ACCOUNT correctly"
      return

    project  = msg.match[1]
    storyId  = msg.match[2]
    storyURL = "https://www.apptrajectory.com/api/#{apiKey}/accounts/#{account}/projects/#{project}/stories/#{storyId}.json"

    msg.http(storyURL).get() (err, res, body) ->
      if err
        msg.send "Trajectory says: #{err}"
        return
      unless res.statusCode is 200
        msg.send "Got me a code #{res.statusCode}"
        return
      story = JSON.parse body
      message = "\"#{story.title}\""
      message += ", assigned to #{story.assignee_name}" if story.assignee_name
      message += " (#{story.state} #{story.task_type.toLowerCase()})"
      msg.send message
