# Description:
#   Renders VividCortex components as images
#
# Configuration:
#   HUBOT_VC_SHARE_ORGANIZATION
#   HUBOT_VC_SHARE_ENVIRONMENT
#   HUBOT_VC_SHARE_TOKEN
#
# Commands:
#   hubot share <top-queries|query-compare|top-processes> last <count> <seconds|minutes|hours|days|month> - Generate a capture of the specified component
#   share top-queries last minute|hour|month
#   share top-queries last N seconds|minutes|hours|months
#   share top-queries last 10 minutes
#   share top-queries last 20 days
#   share top-queries last 3 months
#
# Notes:
#   - Does not support graphs at the moment
#   - The second parameter is harcoded to "last", the plan is making it support multiple values like timestamps.
#
# Author:
#   cesarvarela

# VividCortex api URL
api = "https://app.vividcortex.com/api/v2"

ORGANIZATION = process.env.HUBOT_VC_SHARE_ORGANIZATION # This is the organization nickname, you'll see it in the VividCortex app URL
ENVIRONMENT = process.env.HUBOT_VC_SHARE_ENVIRONMENT # This is the environment ID, you'll see it in the VividCortex app URL too
TOKEN = process.env.HUBOT_VC_SHARE_TOKEN # This is the same token used to install VividCortex


module.exports = (robot) ->

  urls =
    "top-queries"   : "/top-queries?limit=5&rankBy=time_us&rank=queries&selectedProfile=&UIMode=normal&filter=&filterTagName=&filterTagValue=&columns=Count&columns=First%20Seen&columns=Action&columns=Notifications&hosts="
    "query-compare" : "/query-compare?limit=5&rankBy=time_us&rank=queries&filter=&hosts="
    "top-processes" : "/top-processes?limit=5&filter=&rankBy=user_us&hosts="

  getURL = (component, since = "last", count = 1, unit = "minutes", msg) ->

    base = "/#{ORGANIZATION}/#{ENVIRONMENT}"
    from = 0
    till = 0

    if since == "last"

      switch unit
      when "seconds", "second" then from = 1
      when "minutes", "minute" then from = 60
      when "hours", "hour" then from  = 3600
      when "days", "day" then from  = 3600 * 24
      when "months", "month" then from  = 3600 * 24 * 30

      msg.send since, count, unit

    range =  "&from=" + (-from * count) + "&until=" + till
    url = base + urls[component] + range

    msg.send "Loading #{url}"

    return url

  loadShare = (config = 2, msg) ->

    msg.send "Capturing #{config.component}, say cheese..."

    robot.http("#{api}/share/capture?selector=" + encodeURIComponent(config.selector) + "&url=" + encodeURIComponent(config.url))
    .header('Accept', 'application/json')
    .header('Authorization', "Bearer #{TOKEN}")
    .get() (err, res, body) ->
      # error checking code here
      try
        data = JSON.parse(body)
      catch e
        msg.send "Invalid api response: #{body}"

      if data and 'url' of data
        msg.send data.url

  robot.respond /share (.+)/i, (msg) ->

    commandArray = msg.match[1].replace(/^\s+|\s+$/g, "").split(/\s+/)

    component = commandArray[0]
    since = commandArray[1]

    if commandArray[2].match /^\d+$/
      count = parseInt commandArray[2]
      unit = commandArray[3]
    else
      count = 1
      unit = commandArray[2]

    if component of urls
      config =
        component: component
        selector: "[vc-shareable=\"#{component}\"]"
        url: getURL(component, since, count, unit, msg)

      loadShare(config, msg)

    else
      msg.send "Component #{component} not defined."