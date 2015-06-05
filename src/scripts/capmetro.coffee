# Description:
#   Get arrival time of CapMetro buses (http://www.capmetro.org/)
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot capmetro stopID - Get the schedule of the bus stop, with the stop's ID being stopID
#
# Author:
#   Ricardo Cruz - @rkrdo

module.exports = (robot) ->

  robot.respond /capmetro (\d*)/i, (msg) ->

    stopID = msg.match[1]
    url = "http://www.capmetro.org/planner/s_nextbus2.asp?stopid=#{stopID}&opt=2"

    msg.http(url)
      .get() (err, res, body) ->
        resp = JSON.parse(body)
        if resp.status is "OK"
          msg.send "Route: #{resp.routeDesc}"
          msg.send "Stop: #{resp.stopDesc}"
          for arrival, i in resp.list
            do (arrival) ->
              msg.send "Trip ##{i + 1}"
              msg.send "\tScheduled Arrival: #{arrival.sched}"
              msg.send "\tEstimated Arrival: #{arrival.est}"
        else
          msg.send "Stop with ID ##{stopID} wasn't found"

