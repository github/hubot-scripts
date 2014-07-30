# Description:
#   tombola feature toggle functionality for hubot.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ft status <toggle_name> <country> --<environment> - Returns whether or not the toggle is active
#   hubot ft status <toggle_name> for <country> on <environment>
#
#   hubot toggle <toggle_name> <country> --<environment> - Toggles the feature
#   hubot toggle <toggle_name> for <country> on <environment>
#
# Notes:
#   match[2] = feature toggle name
#   match[3] = target country
#   match[4] = target environment
# Author:
#   tombola <marc-costello>

module.exports = (robot) ->
  
  api =
    uk:
        dev: "https://dev.tombola.co.uk/new/api/"
        stage: "https://stage.tombola.co.uk/new/api/"
        #live: "http://tombola.co.uk/new/api/"
    es:
	    dev: "https://dev.tombola.co.uk/new/api/"
	    stage: "https://stage.tombola.co.uk/new/api/"
	    #live: "http://tombola.co.uk/new/api/"
    bg:
	    dev: "https://dev.tombola.co.uk/new/api/"
	    stage: "https://stage.tombola.co.uk/new/api/"
	    #live: "http://tombola.co.uk/new/api/"
  
  getApiUrl = (country, env) ->
    return null if !country
    env = env || 'dev'
    
    country = country.toLowerCase()
    env = env.toLowerCase()
    api[country][env]
  
  # toggle
  toggle = (msg) ->
    selectedApi = getApiUrl msg.match[3], msg.match[4]
    return if not selectedApi?
    robot.http(selectedApi + 'v2/featuretoggle/' + msg.match[2])
        .headers('Content-Type': 'application/json', Accept: 'application/json')
        .put() (err, res, body) ->
            if res.statusCode is 204 #success (no content)
                msg.send("Just toggled " + msg.match[2] + " haven't a")
            else
                resBody = JSON.parse(body)
                msg.send("Sorry chief, " + resBody.customerMessage)
  
  robot.respond /(toggle) (.*) (.*) --(.*)/i, toggle
  robot.respond /(toggle) (.*) for (.*) on (.*)/i, toggle
  
  # ft status
  isActive = (msg) ->
    selectedApi = getApiUrl msg.match[3], msg.match[4]
    return if not selectedApi?
    robot.http(selectedApi + 'v2/featuretoggle/' + msg.match[2])
        .headers(Accept: 'application/json')
        .get() (err, res, body) ->
            resBody = JSON.parse(body)
            if res.statusCode is 200 #success (OK)
                msg.send(msg.match[2] + " : " + resBody)
            else
                msg.send("Sorry chief, " + resBody.customerMessage)    
  
  robot.respond /(ft status) (.*) (.*) --(.*)/i, isActive
  robot.respond /(ft status) (.*) for (.*) on (.*)/i, isActive