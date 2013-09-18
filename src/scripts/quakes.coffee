# Description:
#   Ask hubot about the recent earthquakes in the last (hour, day, week or month).
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot quakes (intensity|all|significant) (period) [limit]
#
# Author:
#   EnriqueVidal

lookup_site = "http://earthquake.usgs.gov"

module.exports = (robot)->
  robot.respond /quakes (([12](\.[05])?)|all|significant)? (hour|day|week|month)( \d+)?$/i, (message)->
    check_for_rapture message, message.match[1], message.match[4], parseInt( message.match[5] )

  check_for_rapture = (message, intensity, period, limit)->
    rapture_url = [ lookup_site, "earthquakes", "feed", "geojson", intensity, period ].join '/'

    message.http( rapture_url ).get() (error, response, body)->
      return message.send 'Sorry, something went wrong' if error

      list  = JSON.parse( body ).features
      count = 0

      for quake in list
        count++
        quake = quake.properties
        time  = build_time quake
        url   = quake.url

        message.send "Magnitude: #{ quake.mag }, Location: #{ quake.place }, Time: #{ time } - #{ url }"

        break if count is limit

    build_time = ( object )->
      time = new Date object.time * 1000
      [ time.getHours(), time.getMinutes(), time.getSeconds() ].join ':'
