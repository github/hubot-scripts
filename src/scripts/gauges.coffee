# Description:
#   Allows Hubot to fetch statistics from Gaug.es
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GAUGES_TOKEN
#
# Commands:
#   hubot gauges for (today|yesterday) - Get views/people from today or yesterday
#   hubot gauges for YYYY-MM-DD - Get views/people for the specified date
#
# Notes:
#   Also you can trigger a event to call gauges in another script
#     Example:
#
#       module.exports = (robot) ->
#         robot.respond /emit gauges/i, (msg) ->
#            robot.emit "gauges", { user: msg.user, for: 'today' }
#
# Author:
#   tombell

class Gauges
  constructor: (@robot, @token) ->

  getViewsForToday: (callback) ->
    @getGauges (err, data) ->
      return callback err if err
      callback null, data.gauges.map (g) ->
        title: g.title
        views: g.today.views
        people: g.today.people

  getViewsForYesterday: (callback) ->
    @getGauges (err, data) ->
      return callback err if err
      callback null, data.gauges.map (g) ->
        title: g.title
        views: g.yesterday.views
        people: g.yesterday.people

  getViewsForDate: (date, callback) ->
    @getGauges (err, data) ->
      return callback err if err
      gauges = []
      for g in data.gauges
        days = g.recent_days.filter (d) ->
          d.date is date
        gauges.push days.map (d) ->
          title: g.title
          views: d.views
          people: d.people
      callback null, gauges

  getGauges: (callback) ->
    @robot.http("https://secure.gaug.es/gauges")
      .headers("X-Gauges-Token": @token)
      .get() (err, res, body) ->
        return callback err if err

        if res.statusCode is 200
          try
            data = JSON.parse body
            callback null, data
          catch err
            callback err
        else
          callback "Could not get gauges for today"

module.exports = (robot) ->

  robot.respond /gauges for (today|yesterday)/i, (msg) ->
    day = msg.match[1]
    robot.emit "gauges", { msg: msg, for: day }

  robot.respond /gauges for (\d{4}-\d{2}-\d{2})/i, (msg) ->
    day = msg.match[1]
    robot.emit "gauges", { msg: msg, for: 'data' , day: day }

  robot.on "gauges", (data) ->
    gauges = new Gauges robot, process.env.HUBOT_GAUGES_TOKEN

    handler = (err, list) ->
      return data.msg.send "An error occured: #{err}" if err
      for g in list
        data.msg.send "#{g.title}: Views #{g.views} People #{g.people}"

    switch data.for
      when "today"
        gauges.getViewsForToday handler
      when "yesterday"
        gauges.getViewsForYesterday handler
      when "data"
        gauges.getViewsForDate data.day, handler
