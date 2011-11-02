# Listen for a specific story from PivotalTracker
#
# You need to set the following variables:
#   HUBOT_PIVOTAL_TOKEN = <API token>
#
# paste a pivotal tracker link or type "sid-####" in the presence of hubot
module.exports = (robot) ->
   robot.hear /(sid-|SID-|pivotaltracker.com\/story\/show)/i, (msg) ->
    Parser = require("xml2js").Parser
    token = process.env.HUBOT_PIVOTAL_TOKEN
    story_id = msg.message.text.match(/\d+$/) # look for some numbers in the string

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

