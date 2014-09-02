# Description:
#   Display current apps info from New Relic
#
# Dependencies:
#   NONE
#
# Configuration:
#   HUBOT_NEWRELIC_API_KEY
#
# Commands:
#   hubot newrelic apps - Returns apps connected to the api key
#
# Notes:
#   NONE
#
# Author:
#   okuramasafumi

url = (resource) ->
  "https://api.newrelic.com/v2/#{resource}.json"

http_request = (msg, target) ->
  msg.http(target).header('X-Api-Key', process.env.HUBOT_NEWRELIC_API_KEY)

appList = (msg) ->
  http_request(msg, url('applications')).get() (err, res, body) ->
    if err
      msg.send "New Relic says: #{err}"
      return
    else
      applications = JSON.parse(body).applications
      response = "You have #{applications.length} apps:\n"
      for app in applications
        response += "id: #{app.id}, name: #{app.name}\n"
        summary = app.application_summary
        response += "  response_time: #{summary.response_time}, throughput: #{summary.throughput}, error_rate: #{summary.error_rate}\n"
      msg.send response



module.exports = (robot) ->
  robot.respond /newrelic (.*)/i, (msg) ->
    action = msg.match[1]
    switch action
      when 'apps' then appList(msg)
      else msg.reply "I don't understand '#{action}'"
