# Description:
#   Get current stories from PivotalTracker
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_PIVOTAL_TOKEN
#   HUBOT_PIVOTAL_PROJECT
#
# Commands:
#   show me stories for <project> - shows current stories being worked on
#   pivotal story <story_id> - shows story title, owner and status
#
# Author:
#   assaf

Parser = require("xml2js").Parser

module.exports = (robot) ->
  robot.respond /show\s+(me\s+)?stories(\s+for\s+)?(.*)/i, (msg)->
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
            msg.http("https://www.pivotaltracker.com/services/v3/projects/#{project.id}/iterations/current").headers("X-TrackerToken": token).query(filter: "state:unstarted,started,finished,delivered").get() (err, res, body) ->
              if err
                msg.send "Pivotal says: #{err}"
                return
      
              (new Parser).parseString body, (err, json)->
                for story in json.iteration.stories.story
                  message = "##{story.id['#']} #{story.name}"
                  message += " (#{story.owned_by})" if story.owned_by
                  message += " is #{story.current_state}" if story.current_state && story.current_state != "unstarted"
                  msg.send message
            return
        msg.send "No project #{project_name}"

  robot.respond /(pivotal story)? (.*)/i, (msg)->
    token = process.env.HUBOT_PIVOTAL_TOKEN
    project_id = process.env.HUBOT_PIVOTAL_PROJECT
    story_id = msg.match[2]

    msg.http("http://www.pivotaltracker.com/services/v3/projects").headers("X-TrackerToken": token).get() (err, res, body) ->
      if err
        msg.send "Pivotal says: #{err}"
        return
      (new Parser).parseString body, (err, json)->
        for project in json.project
          msg.http("https://www.pivotaltracker.com/services/v3/projects/#{project.id}/stories/#{story_id}").headers("X-TrackerToken": token).get() (err, res, body) ->
            if err
              msg.send "Pivotal says: #{err}"
              return
            if res.statusCode != 500
              (new Parser).parseString body, (err, story)->
                if !story.id
                  return
                message = "##{story.id['#']} #{story.name}"
                message += " (#{story.owned_by})" if story.owned_by
                message += " is #{story.current_state}" if story.current_state && story.current_state != "unstarted"
                msg.send message
                storyReturned = true
                return
    return
