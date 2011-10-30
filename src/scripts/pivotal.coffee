# Get current stories from PivotalTracker
#
# You need to set the following variables:
#   HUBOT_PIVOTAL_TOKEN = <API token>
#
# If you're working on a single project, you can set it once:
#   HUBOT_PIVOTAL_PROJECT = <project name>
#
# Otherwise, include the project name in your message to Hubot.
#
# show me stories for <project> -- shows current stories being worked on
module.exports = (robot) ->
  robot.respond /show\s+(me\s+)?stories\s+(for\s+)?(.*)/i, (msg)->
    Parser = require("xml2js").Parser
    token = process.env.HUBOT_PIVOTAL_TOKEN
    project_name = msg.match[3]
    if project_name == ""
      project_name = RegExp(process.env.HUBOT_PIVOTAL_PROJECT, "i")
    else
      project_name = RegExp(project_name + ".*", "i")

    msg.http("http://www.pivotaltracker.com/services/v3/projects").headers("X-TrackerToken": token).get() (err, res, body) ->
      if err
        msg.send "Pivotal says: #{err}"
        return
      (new Parser).parseString body, (err, json)->
        for project in json.project
          if project_name.test(project.name)
            msg.http("https://www.pivotaltracker.com/services/v3/projects/#{project.id}/stories").headers("X-TrackerToken": token).query(filter: "state:unstarted,started,finished,delivered").get() (err, res, body) ->
              if err
                msg.send "Pivotal says: #{err}"
                return
      
              (new Parser).parseString body, (err, json)->
                for story in json.story
                  message = "##{story.id['#']} #{story.name}"
                  message += " (#{story.owned_by})" if story.owned_by
                  message += " is #{story.current_state}" if story.current_state && story.current_state != "unstarted"
                  msg.send message
            return
        msg.send "No project #{project_name}"
