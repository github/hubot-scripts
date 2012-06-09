# Description:
#   Get a snow report from onthesnow.com
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot snow in <two letter state name> - Displays resort info for a state, .e.g., snow in CO
#   hubot snow at <resort>, <two letter state name> - Displays info for a single resort
#
# Author:
#   rwc9u

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /snow in (\w+)/i, (msg) ->
    snow_report(msg, msg.match[1], null)
  robot.respond /snow at (.+), (\w+)/i, (msg) ->
    snow_report(msg, msg.match[2], msg.match[1])


snow_report = (msg, state, resort) ->
  if state == "CA"
    # onthesnow splits CA into CN and CS but they have the same resorts
    get_snow_report(msg,"http://www.onthesnow.com/CN/snow.rss",resort)
  else
    get_snow_report(msg,"http://www.onthesnow.com/#{state}/snow.rss",resort)

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
          output = ""
          for area in result.channel.item
            if resort? and resort == area.title
              output =  "#{area.title} - #{area.description}"
            else
              output += "#{area.title} - #{area.description}\n" unless resort?
          msg.send output
