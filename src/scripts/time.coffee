# Description:
#   Returns local time in given city.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_WWO_API_KEY
#
# Commands:
#   hubot time in <city> - Get current time in city
#
# Notes
#   Request an WWO API KEY in http://www.worldweatheronline.com/
#
#   City parameter can be:
#     city
#     city, country
#     ip address
#     latitude and longitude (in decimal)
#
# Author:
#   gtoroap
#
module.exports = (robot) ->
  robot.respond /time in (.*)/i, (msg) ->
    unless process.env.HUBOT_WWO_API_KEY
      msg.send 'Please, set HUBOT_WWO_API_KEY environment variable'
      return
    msg.http('http://www.worldweatheronline.com/feed/tz.ashx')
      .query({
        q: msg.match[1]
        key: process.env.HUBOT_WWO_API_KEY
        format: 'json'
      })
      .get() (err, res, body) ->
        try
          result = JSON.parse(body)['data']
          city = result['request'][0]['query']
          currentTime = result['time_zone'][0]['localtime'].slice 11
          msg.send "Current time in #{city} ==> #{currentTime}"
        catch error
          msg.send "Sorry, no city found. Please, check your input and try it again"

