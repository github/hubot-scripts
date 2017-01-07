# Description:
#   Airtime API Interaction for Hubot (http://www.sourcefabric.org/en/airtime/)
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_AIRTIME_URL - URL to Airtime installation (ie.: http://airtime.myhost.com)
#
#   How to find you HUBOT_AIRTIME_URL: 
#   If you log into your Airtime installation at http://airtime.myhost.com/login 
#   then the HUBOT_AIRTIME_URL will be "http://airtime.myhost.com" (without the quotes).
#   
#   To launch hubot locally with the correct environment variable value: 
#   HUBOT_AIRTIME_URL=http://airtime.myhost.com ./bin/hubot
#   To add the correct environment variable to an existing and working Heroku deployment, you'll issue something like: 
#   heroku config:add HUBOT_AIRTIME_URL=http://airtime.myhost.com
#
# Commands:
#   hubot airtime now - Display what's currently broadcasted on this Airtime installation
#   hubot airtime next track - Displays what will be the next track to be broadcasted on Airtime
#   hubot airtime next show - Displays what will be the next show broadcasted on Airtime
#   hubot airtime previous track - Displays what has just been broadcasted on Airtime
#
# Notes: 
#   Airtime is a free and open source radio automation software (http://www.sourcefabric.org/en/airtime/)
#   Source code is available on GitHub (https://github.com/sourcefabric/Airtime)
#   Airtime Pro is the SaaS version, hosted by its creators Sourcefabric, of open source Airtime (http://www.sourcefabric.org/en/airtime/airtimepro)
# 
# Author:
#   sjourdan

validEnvironment = (msg) ->
  if process.env.HUBOT_AIRTIME_URL
    true
  else
    msg.send "Please set the HUBOT_AIRTIME_URL environment variable."
    false

module.exports = (robot) ->

  robot.respond /airtime now/i, (msg) ->
    return unless validEnvironment(msg)
    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      json= JSON.parse(body)
      track = json.current.name
      show = json.currentShow[0].name
      msg.send "Now playing: #{track} on #{show}" 

  robot.respond /airtime next track/i, (msg) ->
    return unless validEnvironment(msg)
    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      json= JSON.parse(body)
      track = json.next.name
      starts = json.next.starts.split " "
      time = starts[1]
      tz = json.timezone
      msg.send "Coming next: #{track} at #{time} #{tz}" 

  robot.respond /airtime next show/i, (msg) ->
    return unless validEnvironment(msg)
    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      json= JSON.parse(body)
      show = json.nextShow[0].name
      starts = json.nextShow[0].starts.split " "
      time = starts[1]
      tz = json.timezone
      msg.send "Next show is: #{show} at #{time} #{tz}" 

  robot.respond /airtime previous track/i, (msg) ->
    return unless validEnvironment(msg)
    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      json= JSON.parse(body)
      track = json.previous.name
      starts = json.previous.starts.split " "
      time = starts[1]
      tz = json.timezone
      msg.send "Just played: #{track} at #{time} #{tz}"
