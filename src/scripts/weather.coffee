# Returns weather information from Google
#
# weather <city> - Get the weather for a location
# forecast <city> - Get the forecast for a location
jsdom = require 'jsdom'
env = process.env

module.exports = (robot) ->
  robot.respond /forecast(?: me|for|in)?\s(.*)/, (msg) ->
    query msg, (body, err) ->
      return msg.send err if err

      city = body.getElementsByTagName("city")[0]
      return msg.send "Sorry, but I couldn't find that location." if not city or not city.getAttribute
      
      city = city.getAttribute("data")

      strings = []
      
      strings.push "The forecast for #{city} is as follows:\n"
      for element in body.getElementsByTagName("forecast_conditions")
        day = element.getElementsByTagName("day_of_week")[0].getAttribute("data")
        
        if env.HUBOT_WEATHER_CELSIUS
          low = convertTempToCelsius(element.getElementsByTagName("low")[0].getAttribute("data")) + "ºC"
        else
          low = element.getElementsByTagName("low")[0].getAttribute("data") + "ºF"
        
        if env.HUBOT_WEATHER_CELSIUS
          high = convertTempToCelsius(element.getElementsByTagName("high")[0].getAttribute("data")) + "ºC"
        else
          high = element.getElementsByTagName("high")[0].getAttribute("data") + "ºF"
        
        condition = element.getElementsByTagName("condition")[0].getAttribute("data")
        strings.push "#{day}: #{condition} with a high of #{high} and a low of #{low}."

      msg.send strings.join "\n"

  robot.respond /weather(?: me|for|in)?\s(.*)/, (msg) ->
    query msg, (body, err) ->
      return msg.send err if err

      city = body.getElementsByTagName("city")[0]
      return msg.send "Sorry, but you didn't specify a location." if not city or not city.getAttribute
      
      city = city.getAttribute("data")
      currentCondition = body.getElementsByTagName("current_conditions")[0].getAttribute("data")
      conditions = body.getElementsByTagName("current_conditions")[0].getElementsByTagName("condition")[0].getAttribute("data")
      humidity = body.getElementsByTagName("current_conditions")[0].getElementsByTagName("humidity")[0].getAttribute("data").split(' ')[1]

      if env.HUBOT_WEATHER_CELSIUS
        temp = body.getElementsByTagName("current_conditions")[0].getElementsByTagName("temp_c")[0].getAttribute("data") + "ºC"
      else
        temp = body.getElementsByTagName("current_conditions")[0].getElementsByTagName("temp_f")[0].getAttribute("data") + "ºF"
      
      msg.send "Currently in #{city} it is #{conditions} and #{temp} with a humidity of #{humidity}.\n"

  getDom = (xml) ->
    body = jsdom.jsdom(xml)
    throw Error("No XML data returned.") if body.getElementsByTagName("weather")[0].childNodes.length == 0
    body

  convertTempToCelsius = (f) ->
    ((5 / 9) * (f - 32)).toFixed 0

  query = (msg, cb) ->
    location = msg.match[1]
    msg.http("http://www.google.com/ig/api")
      .query(weather: location)
      .get() (err, res, body) ->
        try
          body = getDom body
        catch err
          err = "Could not fetch weather data."
        cb(body, err)
