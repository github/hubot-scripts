# Description
#   Gets visits stats from Google Analytics
#
# Dependencies:
#   "date-utils": ">=1.2.5",
#   "googleanalytics": "0.3.6"
#
# Configuration:
#   HUBOT_ANALYTICS_USER
#   HUBOT_ANALYTICS_PASSWD
#   HUBOT_ANALYTICS_PROFILE_ID
#
# Commands:
#   hubot how many visits we had last year|month|week|yesterday?
#
# Notes:
#   
#
# Author:
#   ghvillasboas (based on a work by Artsy Editorial)

GA = require('googleanalytics')
util = require('util')
require('date-utils')
   
module.exports = (robot) ->
  robot.respond /how many (visits|visitors|sessions|session|access|users|pageviews|page views) we had (.* year|.* month|.* week|yesterday).*/i, (msg) ->
    scope = msg.match[2]

    config = { "user": process.env.HUBOT_ANALYTICS_USER, "password": process.env.HUBOT_ANALYTICS_PASSWD }
    
    ga = new GA.GA(config);

    ga.login (err, token) ->
      
      start_date = Date.today().add({ months: -1 }).toYMD("-")

      # format scope of starting dates
      if /yesterday/.test(scope)
        start_date = Date.yesterday().toYMD("-")
      else if /.* week/.test(scope)
        start_date = Date.today().add({ weeks: -1 }).toYMD("-")
      else if /.* year/.test(scope)
        start_date = Date.today().add({ years: -1 }).toYMD("-"))

      end_date = Date.today().toYMD("-")
      
      options = {
        'ids': "ga:#{process.env.HUBOT_ANALYTICS_PROFILE_ID}",
        'start-date': start_date,
        'end-date': end_date,
        'metrics': 'ga:sessions, ga:pageviews, ga:avgSessionDuration, ga:percentNewSessions'
      }

      ga.get(options, (err, entries) ->

        message = ""

        visits = entries[0]["metrics"][0]["ga:sessions"]
        pageviews = entries[0]["metrics"][0]["ga:pageviews"]
        percentNew = parseInt( entries[0]["metrics"][0]["ga:percentNewSessions"], 10 )
        onlineTime = parseInt( entries[0]["metrics"][0]["ga:avgSessionDuration"] )

        # format message
        if /yesterday/.test(scope)
          message += "Yesterday we had "
        else if /.* week/.test(scope)
          message += "Last week we had "
        else if /.* year/.test(scope)
          message += "Last year we had "
        else
          message += "Last month we had "

        message += "#{visits} sessions (#{percentNew}% new) and #{pageviews} pageviews. Average session duration: #{convertoToHHMMSS onlineTime}"
        
        msg.reply message 
      )

convertoToHHMMSS = (seconds) ->
  # multiply by 1000 because Date() requires miliseconds
  date = new Date(seconds * 1000)
  hh = date.getUTCHours()
  mm = date.getUTCMinutes()
  ss = date.getSeconds()

  # This line gives you 12-hour (not 24) time
  if hh > 12
    hh = hh - 12
  
  # These lines ensure you have two-digits
  if hh < 10
    hh = "0" + hh
  if mm < 10
    mm = "0"+mm
  if ss < 10
    ss = "0"+ss

  # This formats your string to HH:MM:SS
  "#{hh}:#{mm}:#{ss}"