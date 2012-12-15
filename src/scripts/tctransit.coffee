# Description:
#   Allows users to check MetroTransit times in the TwinCities
#   metrotransit.herokuapp.com
#
# Dependencies:
#   none
# 
# Configuration:
#   none
#
# Commands:
#   hubot when is the next <route #> going <north/south/east/west> from <4 letter stop code OR street name>
#
# Author:
#   pyro2927

module.exports = (robot) ->
  robot.respond /when is the next (.*) going (.*) from (.*)/i, (msg) ->
    route = msg.match[1]
    direction = msg.match[2]
    dirNum = 4
    if direction.toLowerCase() == "east"
      dirNum = 2
    else if direction.toLowerCase() == "west"
      dirNum = 3
    else if direction.toLowerCase() == "south"
      dirNum = 1

    stop = msg.match[3]
    if (stop.length != 4)
      TransitAPI.search_stop_codes(route, dirNum, stop, msg)
    else
      TransitAPI.fetch_next_stop(route, dirNum, stop, msg)
    

class TransitAPI
  constructor: ->

  fetch_next_stop: (route, dirNum, stopCode, msg) =>
    msg.http('http://metrotransit.herokuapp.com/nextTrip?route=' + route + '&direction=' + dirNum + '&stop=' + stopCode)
      .get() (err, res, body) =>
        stops = JSON.parse(body)
        if stops.count <= 0
          msg.send "No next stops"
          return
        time = stops[0].time
        if time.match(/Min$/)
          time = "in " + time
        else if time.match(/:/)
          time = "at " + time
        msg.send "The next " + route + " at " + stops[0].stop_name + " is " + time

  search_stop_codes: (route, dirNum, stopName, msg) =>
    msg.http('http://metrotransit.herokuapp.com/stops?route=' + route + '&direction=' + dirNum)
      .get() (err, res, body) =>
        stops = JSON.parse(body)
        # too bad, no stops found for this
        if stops.count <= 0
          msg.send "No stops available for the " + route + " going that direction"
          return
        # see if any of our stops match
        for stop in stops
          if stop.name.toLowerCase().indexOf(stopName.toLowerCase()) > -1
            this.fetch_next_stop(route, dirNum, stop.key, msg)
            return
        msg.send "No stops found with name: " + stopName

TransitAPI = new TransitAPI()