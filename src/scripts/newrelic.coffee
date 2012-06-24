# Description:
#   Display current app performance stats from New Relic
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_NEWRELIC_ACCOUNT_ID
#   HUBOT_NEWRELIC_APP_ID
#   HUBOT_NEWRELIC_API_KEY
# 
# Commands:
#   hubot newrelic me - Returns summary application stats from New Relic
#
# Notes:
#   How to find these settings:
#   After signing into New Relic, select your application
#   Given: https://rpm.newrelic.com/accounts/xxx/applications/yyy
#     xxx is your Account ID and yyy is your App ID
#   Account Settings > API + Web Integrations > API Access > "API key"
# 
# Author:
#   briandoll

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
