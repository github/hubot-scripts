# Description:
#   Creates a new story in PivotalTracker
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PIVOTAL_TOKEN
#   HUBOT_PIVOTAL_PROJECT
#
# Commands:
#   bug <story> - creates a new bug in pivotal tracker
#   chore <story> - creates a new chore in pivotal tracker
#   feature <story> - creates a new feature in pivotal tracker
#
# Author:
#   mistasparks

module.exports = (robot) ->
  robot.respond /(feature|bug|chore) (.*)/i, (msg)->
    token = process.env.HUBOT_PIVOTAL_TOKEN
    project_id = process.env.HUBOT_PIVOTAL_PROJECT
    story_type = msg.match[1]
    story = msg.match[2]

    data = JSON.stringify({
      name: story,
      story_type: story_type
    })

    robot.http("https://www.pivotaltracker.com/services/v5/projects/#{project_id}/stories")
      .header('Content-Type', 'application/json')
      .header('X-TrackerToken', token)
      .post(data) (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return

        response = JSON.parse(body)

        msg.send "#{story}: #{response.url}"