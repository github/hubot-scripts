# Description:
#   Looks up jira issues when they're mentioned in chat
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_DOMAIN
#
# Commands:
# 
# Author:
#   stuartf

module.exports = (robot) ->
  cache = []
  jiraDomain = process.env.HUBOT_JIRA_DOMAIN
  jiraUrl = "https://" + jiraDomain
  http = require 'https'

  http.get {host: jiraDomain, path: "/rest/api/2.0.alpha1/project"}, (res) ->
    data = ''
    res.on 'data', (chunk) ->
      data += chunk.toString()
    res.on 'end', () ->
      json = JSON.parse(data)
      jiraPrefixes = ( entry.key for entry in json )
      reducedPrefixes = jiraPrefixes.reduce (x,y) -> x + "-|" + y
      jiraPattern = "/(" + reducedPrefixes + "-)(\\d+)/gi"

      robot.hear eval(jiraPattern), (msg) ->
        for i in msg.match
          issue = i.toUpperCase()
          now = new Date().getTime()
          if cache.length > 0
            cache.shift() until cache.length is 0 or cache[0].expires >= now
          if cache.length == 0 or (item for item in cache when item.issue is issue).length == 0
            cache.push({issue: issue, expires: now + 120000})
            msg.http(jiraUrl + "/rest/api/2.0.alpha1/issue/" + issue)
              .get() (err, res, body) ->
                try
                  key = JSON.parse(body).key
                  msg.send "[" + key + "] " + JSON.parse(body).fields.summary.value
                  urlRegex = new RegExp(jiraUrl + "[^\\s]*" + key)
                  if not msg.message.text.match(urlRegex)
                    msg.send jiraUrl + "/browse/" + key
                catch error
                  try
                    msg.send "[*ERROR*] " + JSON.parse(body).errorMessages[0]
                  catch reallyError
                    msg.send "[*ERROR*] " + reallyError
