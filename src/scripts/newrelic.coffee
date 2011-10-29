# Display current app performance stats from New Relic
#
# You need to set the following variables:
#   HUBOT_NEWRELIC_ACCOUNT_ID = "<Account ID>"
#   HUBOT_NEWRELIC_APP_ID     = "<Application ID>"
#   HUBOT_NEWRELIC_API_KEY    = "<API Key>"
# 
# How to find these settings:
#   After signing into New Relic, select your application
#   Given: https://rpm.newrelic.com/accounts/xxx/applications/yyy
#     xxx is your Account ID and yyy is your App ID
#   Account Settings > API + Web Integrations > API Access > "API key"
# 
# TODO:
#  - Allow hubot to display all app stats for a given account using the View Applications API call
#    https://github.com/newrelic/newrelic_api
#  - Allow you to specify the name of the app to fetch metrics for:
#    hubot newrelic me "My App Name"
#
# hubot <newrelic me> - Returns summary application stats from New Relic
module.exports = (robot) ->
  robot.respond /newrelic me/i, (msg) ->
    accountId = process.env.HUBOT_NEWRELIC_ACCOUNT_ID
    appId     = process.env.HUBOT_NEWRELIC_APP_ID
    apiKey    = process.env.HUBOT_NEWRELIC_API_KEY
    Parser = require("xml2js").Parser
    
    msg.http("https://rpm.newrelic.com/accounts/#{accountId}/applications/#{appId}/threshold_values.xml?api_key=#{apiKey}")
      .get() (err, res, body) ->
        if err
          msg.send "New Relic says: #{err}"
          return
        (new Parser).parseString body, (err, json)->
          for threshold_value in json['threshold_value']
            msg.send "  #{threshold_value['@']['name']} : #{threshold_value['@']['formatted_metric_value']}"
          msg.send "  https://rpm.newrelic.com/accounts/#{accountId}/applications/#{appId}"