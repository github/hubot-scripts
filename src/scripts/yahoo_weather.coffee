# Description:
#   Yahoo's Weather.
#
# Dependencies:
#   "jsdom": ""
#   "jquery": ""
#
# Configuration:
#   HUBOT_WEATHER_CELSIUS - Display in celsius.
#
# Commands:
#   hubot weather for <location> - Get location's weather.
#
# Author:
#   nebiros

jsdom = require("jsdom").jsdom

queryWeather = (location, callback) ->
  q = "SELECT * FROM weather.bylocation WHERE location='" + location + "'"
  q += " AND unit='c'" if process.env.HUBOT_WEATHER_CELSIUS
  q += " LIMIT 1"

  url = "http://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent(q) + "&format=json&env=" + encodeURIComponent("store://datatables.org/alltableswithkeys") + "&callback=?"

  window = jsdom().createWindow()  
  $ = require("jquery").create(window)

  $.getJSON url, callback

module.exports = (robot) ->
  robot.respond /weather for (.+)$/i, (msg) ->
    queryWeather msg.match[1], (data, textStatus, jqXHR) ->
      if data.query.count <= 0
        msg.send "Location '#{msg.match[1]}'' not found."
        return

      temp = data.query.results.weather.rss.channel.item.condition.temp

      if not temp?
        msg.send "Location '#{msg.match[1]}'' not found."
        return

      text = data.query.results.weather.rss.channel.item.condition.text
      console.log(temp, text)
      unit = "fahrenheit"
      unit = "celsius" if process.env.HUBOT_WEATHER_CELSIUS

      out = temp + " " + unit + " degrees, " + text
      msg.send out