# Description:
#   Airtime API Interaction for Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_AIRTIME_URL - URL to Airtime installation, like http://airtime.myhost.com
#
# Commands:
#   hubot airtime now - Display what's currently broadcasted on Airtime
#   hubot airtime next track - Displays what will be the next track to be broadcasted on Airtime
#   hubot airtime next show - Displays what will be the next show broadcasted on Airtime
#   hubot airtime previous track - Displays what has just been broadcasted on Airtime
#
# Author:
#   sjourdan
  
module.exports = (robot) ->
    
  robot.respond /airtime now/i, (msg) ->
    unless process.env.HUBOT_AIRTIME_URL
      msg.send "Please set the HUBOT_AIRTIME_URL environment variable."
      return

    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      try
        json= JSON.parse(body)
        track = json.current.name
        show = json.currentShow[0].name
        msg.send "Now playing: #{track} on #{show}" 
      catch error
        msg.send "Error: couldn't parse Airtime API on #{process.env.HUBOT_AIRTIME_URL}: #{error}"

  robot.respond /airtime next track/i, (msg) ->
    unless process.env.HUBOT_AIRTIME_URL
      msg.send "Please set the HUBOT_AIRTIME_URL environment variable."
      return

    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      try
        json= JSON.parse(body)
        track = json.next.name
        starts = json.next.starts.split " "
        time = starts[1]
        tz = json.timezone
        msg.send "Coming next: #{track} at #{time} #{tz}" 
      catch error
        msg.send "Error: couldn't parse Airtime API on #{process.env.HUBOT_AIRTIME_URL}: #{error}"
        
  robot.respond /airtime next show/i, (msg) ->
    unless process.env.HUBOT_AIRTIME_URL
      msg.send "Please set the HUBOT_AIRTIME_URL environment variable."
      return

    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      try
        json= JSON.parse(body)
        show = json.nextShow[0].name
        starts = json.nextShow[0].starts.split " "
        time = starts[1]
        tz = json.timezone
        msg.send "Next show is: #{show} at #{time} #{tz}" 
      catch error
        msg.send "Error: couldn't parse Airtime API on #{process.env.HUBOT_AIRTIME_URL}: #{error}"        

  robot.respond /airtime previous track/i, (msg) ->
    unless process.env.HUBOT_AIRTIME_URL
      msg.send "Please set the HUBOT_AIRTIME_URL environment variable."
      return

    msg.http("#{process.env.HUBOT_AIRTIME_URL}/api/live-info")
    .get() (err, res, body) ->
      try
        json= JSON.parse(body)
        track = json.previous.name
        starts = json.previous.starts.split " "
        time = starts[1]
        tz = json.timezone
        msg.send "Just played: #{track} at #{time} #{tz}" 
      catch error
        msg.send "Error: couldn't parse Airtime API on #{process.env.HUBOT_AIRTIME_URL}: #{error}"

