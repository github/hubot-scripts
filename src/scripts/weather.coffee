# Returns the weather results for a given location
#
# what is the weather in <location>
# what's the weather at <location>
#
xml = require('xml2js')

module.exports = (robot) ->
  robot.respond /(what)[\s]*(is|\'s) (the weather) (in|at) (.*)*/i, (msg) ->
    searchWeather msg, msg.match[5], ( result, icon ) ->
      msg.send result
      msg.send icon

searchWeather = (msg, location, cb) ->
  msg.http('http://www.google.com/ig/api')
    .query(weather: location)
    .get() (err, res, body) ->
      parser = new xml.Parser()
      parser.addListener 'end', ( result ) ->
        try
          current_conditions = result['weather']['current_conditions']
          condition      = current_conditions['condition']['@']['data']
          temp_f         = current_conditions['temp_f']['@']['data']
          temp_c         = current_conditions['temp_c']['@']['data']
          humidity       = current_conditions['humidity']['@']['data']
          wind_condition = current_conditions['wind_condition']['@']['data']
          icon           = "http://google.com/#{current_conditions['icon']['@']['data']}"
          condition = "It's #{condition} (#{temp_f}F°/#{temp_c}C° – #{humidity} – #{wind_condition})."
        catch error
          condition = "Sorry, no weather informations for #{location}, better look outside the window."
          icon      = null
        finally
          cb condition, icon

      parser.parseString body

