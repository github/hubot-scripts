# Get some weather action!
#
# weather <city> - Get the weather for a location
# forecast <city> - Get the forecast for a location
JsDom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /forecast(?: me)?\s(.*)/, (msg) ->
    query msg, (body, err) ->
      return msg.send err if err

      strings = []
      for element in body.getElementsByTagName('forecast_conditions')
        day = element.getElementsByTagName('day_of_week')[0].getAttribute('data');
        low = element.getElementsByTagName('low')[0].getAttribute('data');
        high = element.getElementsByTagName('high')[0].getAttribute('data');
        condition = element.getElementsByTagName('condition')[0].getAttribute('data');
        strings.push "#{day} #{condition} high of: #{convertTemp(high)} low of: #{convertTemp(low)}"

      msg.send strings.join "\n"

  robot.respond /weather(?: me)?\s(.*)/, (msg) ->
    query msg, (body, err) ->
      return msg.send err if err

      city = body.getElementsByTagName('city')[0];
      return msg.send 'No city -> no weather.' if not city or not city.getAttribute

      strings = []
      strings.push "Weather for #{city.getAttribute('data')}"
      currentCondition = body.getElementsByTagName('current_conditions')[0];
      conditions = currentCondition.getElementsByTagName('condition')[0];
      temp = currentCondition.getElementsByTagName('temp_c')[0];
      humidity = currentCondition.getElementsByTagName('humidity')[0];

      strings.push("Current conditions: #{conditions.getAttribute('data')} " +
        "#{temp.getAttribute('data')}ºc")

      strings.push humidity.getAttribute('data')
      msg.send strings.join "\n"

  getDom = (xml) ->
    body = JsDom.jsdom(xml)
    throw Error('No xml') if body.getElementsByTagName('weather')[0].childNodes.length == 0
    body

  convertTemp = (faren) ->
    ((5 / 9) * (faren - 32)).toFixed 0

  query = (msg, cb) ->
    location = msg.match[1]
    msg.http('http://www.google.com/ig/api')
      .query(weather: location)
      .get() (err, res, body) ->
        try
          body = getDom body
        catch err
          err = 'Could not fetch weather data :('
        cb(body, err)
