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
#   - The second parameter only accepts "last" as a option, the plan is making it support multiple values like timestamps.
#
# Author:
#   cesarvarela

# VividCortex api URL

api = "https://app.vividcortex.com/api/v2"

# Config

ORGANIZATION = process.env.HUBOT_VC_SHARE_ORGANIZATION # This is the organization nickname, you'll see it in the VividCortex app URL
ENVIRONMENT = process.env.HUBOT_VC_SHARE_ENVIRONMENT # This is the environment ID, you'll see it in the VividCortex app URL too
TOKEN = process.env.HUBOT_VC_SHARE_TOKEN # This is the same token used to install VividCortex

module.exports = (robot) ->

  urls =

  # Customizing this URLS allow us to add/remove columns, filters, sort by, etc.

    "top-queries"   : "/top-queries?limit=5&hosts="
    "query-compare" : "/query-compare?limit=5&hosts="
    "top-processes" : "/top-processes?limit=5&hosts="


  # Generates the url to be loaded before generating the screenshot,
  # the <since> parameter is going to be used in the future

  getURL = (component, since, count, unit) ->

    base = "/#{ORGANIZATION}/#{ENVIRONMENT}"
    from = 0
    till = 0

    switch unit
      when "seconds", "second" then from = 1
      when "minutes", "minute" then from = 60
      when "hours", "hour" then from  = 3600
      when "days", "day" then from  = 3600 * 24
      when "months", "month" then from  = 3600 * 24 * 30
      else from = 3600

    range =  "&from=" + (-from * count) + "&until=" + till
    url = base + urls[component] + range

    return url


  # Creates the api-share request

  loadShare = (config, msg) ->

    msg.send "Capturing #{config.component}, say cheese..."

    robot.http("#{api}/share/capture?selector=" + encodeURIComponent(config.selector) + "&url=" + encodeURIComponent(config.url))
    .header('Accept', 'application/json')
    .header('Authorization', "Bearer #{TOKEN}")
    .get() (err, res, body) ->
      try
        data = JSON.parse(body)
      catch e
        msg.send "Invalid api-share response: #{body}"

      if data and 'url' of data
        msg.send data.url


  # Respond callback

  robot.respond /share (.+)/i, (msg) ->

    commandArray = msg.match[1].replace(/^\s+|\s+$/g, "").split(/\s+/)

    component = commandArray[0]
    since = commandArray[1]

    if commandArray[2]
      if commandArray[2].match /^\d+$/ # check if user specified a number
        count = parseInt commandArray[2]
        unit = commandArray[3]
      else
        count = 1
        unit = commandArray[2]
    else
      count = 1
      unit = "hour"

    if component of urls
      config =
        component: component
        selector: "[vc-shareable=\"#{component}\"]"
        url: getURL(component, since, count, unit, msg)

      loadShare(config, msg)
    else
      msg.send "Component #{component} not defined."