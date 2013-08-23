# Description:
#   Get National Rail live departure information
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DEFAULT_STATION - set the default from station (nearest to your home/office)
#
# Commands:
#   hubot: trains <departure station> to <arrival station>
#   hubot: trains <arrival station>
#   hubot: trains <departure station> to  - lists next 5 departures
#
# Notes:
#   Use the station code (https://en.wikipedia.org/wiki/UK_railway_stations)
#
# Author:
#  JamieMagee

module.exports = (robot) ->
  robot.respond /trains (\w{3})( (to)*(.*))*/i, (msg) ->
    trainFrom = if !!msg.match[4] then msg.match[1].toUpperCase() else process.env.HUBOT_DEFAULT_STATION
    trainTo =  if !!msg.match[4] then msg.match[4].toUpperCase() else msg.match[1].toUpperCase()
    msg.http('http://ojp.nationalrail.co.uk/service/ldb/liveTrainsJson')
      .query({departing: 'true', liveTrainsFrom: trainFrom, liveTrainsTo: trainTo})
      .get() (err, res, body) ->
        stuff = JSON.parse(body)
        if stuff.trains.length
          msg.reply "Next trains from: #{trainFrom} to #{trainTo}"
          for key, value of stuff.trains       
            if key < 5              
              info = "#{value}".split ","
              if !!info[4]
                msg.send "The #{info[1]} to #{info[2]} at platform #{info[4]} is #{/[^;]*$/.exec(info[3])[0].trim().toLowerCase()}"
              else
                msg.send "The #{info[1]} to #{info[2]} is #{/[^;]*$/.exec(info[3])[0].trim().toLowerCase()}"
        else
          msg.send "I couldn't find trains from: #{trainFrom} to #{trainTo}"
