# Description:
#   Get information from the Resumator API.
#
# Configuration:
#   HUBOT_RESUMATOR_APIKEY
#   HUBOT_RESUMATOR_USERNAME
#
# Commands:
#   hubot job list - Returns the current list of jobs from The Resumator
#   hubot job applicants - Returns the current list of applicants in the pipeline of the Resumator

module.exports = (robot) ->
  robot.respond /job list$/i, (msg) ->
    robot.http("https://api.resumatorapi.com/v1/jobs?apikey=#{process.env.HUBOT_RESUMATOR_APIKEY}")
      .get() (err, res, body) ->
        msg.send "#{job.title} > http://#{process.env.HUBOT_RESUMATOR_USERNAME}.theresumator.com/apply/#{job.board_code}" for job in JSON.parse(body)[0..10] when job.status == "Open"

  robot.respond /job applicants$/i, (msg) ->
    robot.http("https://api.resumatorapi.com/v1/applicants?apikey=#{process.env.HUBOT_RESUMATOR_APIKEY}")
      .get() (err, res, body) ->
        msg.send "#{app.first_name} #{app.last_name} for [#{app.job_title}]" for app in JSON.parse(body)[0..10]
