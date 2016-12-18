# Description:
#   Using timezonedb API to get local time for users 
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TIMEZONEDB_API - timezonedb API key
#
# Commands:
#   hubot local time <username> - Returns user local time
#   hubot set time zone for <username> to <timezone> - set timezone for user. Timezone format defined at http://timezonedb.com/time-zones
#   hubot get time zone for <username> - get the user time zone
#   hubot team time zone - get all users timezone
#
# Author:
#   n1tr0g

class TeamTimeZone

  constructor: (@robot, @key) ->
    @url = 'http://api.timezonedb.com/'
    @teamTimeZoneIdentifier = 'team_timezone'

  add: (user, timeZone) ->
    tzData =  @robot.brain.get @teamTimeZoneIdentifier
    if not tzData
      tzData = {}
    tzData[user] = timeZone
    @saveTimeZone(tzData)
    
  saveTimeZone: (data) ->
    @robot.brain.set(@teamTimeZoneIdentifier, data)
   
  getTimeZone: (user) ->
    data =  @robot.brain.get @teamTimeZoneIdentifier
    if data
      data[user] ? null
    else
      null

  getLocalTime: (msg, user, tz, callback) ->
    req_url = "#{@url}?zone=#{tz}&key=#{@key}&format=json"
    msg.http(req_url).get() (err, res, body) ->
      callback(err, res, body)

  teamTimeZone: (callback) ->
    callback(@robot.brain.get @teamTimeZoneIdentifier)

  # check if the user exsists ... its hipchat specific ?
  validate: (user) ->
    if @robot.brain.data.users
      for own key, userData of @robot.brain.data.users
        if userData.mention_name?
          if userData.mention_name.toLowerCase() == user
            return true
    return false


module.exports = (robot) ->

  unless process.env.HUBOT_TIMEZONEDB_API?
    robot.logger.warning 'The HUBOT_TIMEZONEDB_API environment variable not set'
  
  key = process.env.HUBOT_TIMEZONEDB_API ? "NaN"
  teamTimeZone = new TeamTimeZone(robot, key)

  robot.respond /(get time zone)( for)? (.*)/i, (msg) ->
    user = msg.match[3].toLowerCase().replace(/@/,"").replace(/^\s+|\s+$/g, "")
    
    if not teamTimeZone.getTimeZone user
      msg.send "Sorry no timezone defined for #{user}"
    else
      msg.send "Time zone for #{user} is #{teamTimeZone.getTimeZone user}"


  robot.respond /(set time zone)( for)? (.*) to (.*)/i, (msg) ->
    user = msg.match[3].toLowerCase().replace(/@/,"").replace(/^\s+|\s+$/g, "")
    time_zone = msg.match[4].replace(/^\s+|\s+$/g, "")

    if not teamTimeZone.validate user
      msg.send "user '#{user}' doesn't exsists."
    else
      teamTimeZone.add(user, time_zone)
      msg.send "Time zone for '#{user}' is #{time_zone}"


  robot.respond /team time zone/i, (msg) ->
    teamTimeZone.teamTimeZone (data) ->
      response = "team time zone:\n"
      for own user, tz of data
        response += "#{user} is in #{tz}\n"
      msg.send response


  robot.respond /(local time)( for)? (.*)/i, (msg) ->

    user = msg.match[3].toLowerCase().replace(/@/,"").replace(/^\s+|\s+$/g, "")
    
    try
      userTimeZone = teamTimeZone.getTimeZone(user)
      if not userTimeZone
        msg.send "No time zone defined for #{user}"
        return
      
      teamTimeZone.getLocalTime msg, user, userTimeZone, (err, res, body) ->
        response = JSON.parse body
        if response.status == 'OK'
          dateFormat = new Date(response.timestamp*1000)
          msg.send "Local time for #{user} is #{dateFormat.getHours()}:#{dateFormat.getMinutes()}:#{dateFormat.getSeconds()} #{dateFormat.getMonth()+1}/#{dateFormat.getFullYear()}"
        else
          msg.send "Sorry there were some problems retrieving data from the API #{response.status} #{response.message}"

    catch error
      msg.send "Error while trying to process the request #{error}"
