# Get a snow report from onthesnow.com
#
# snow in <two letter state name> - Displays resort info for a state, .e.g., snow in CO
# snow at <resort>, <two letter state name> - Displays infor for a single resort

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /snow in (\w+)/i, (msg) ->
    get_snow_report(msg, "http://www.onthesnow.com/#{msg.match[1]}/snow.rss", null)
  robot.respond /snow at (\w+), (\w+)/i, (msg) ->
    get_snow_report(msg, "http://www.onthesnow.com/#{msg.match[2]}/snow.rss",msg.match[1])


get_snow_report = (msg, url, resort) ->
  msg.http(url)
    .get() (err, res, body) ->
      if res.statusCode is 301
        get_snow_report msg, res.headers.location, resort
      else if res.statusCode is 404
         msg.send "Couldn't find that location."
      else
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          if err
            msg.send "Got: #{err}"
          for area in result.channel.item
            if resort? and resort == area.title
              msg.send "#{area.title} - #{area.description}"
            else
              msg.send "#{area.title} - #{area.description}" unless resort?
