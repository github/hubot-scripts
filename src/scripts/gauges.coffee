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
#
#
# Author:
#   tombell

class Gauges
  constructor: (@robot, @token) ->

  getViewsForToday: (callback) ->
    @getGauges (err, data) ->
      if err? or not data?
        callback err
      else
        gauges = []
        for g in data.gauges
          gauges.push
            title: g.title
            views: g.today.views
            people: g.today.people
        callback null, gauges

  getViewsForYesterday: (callback) ->
    @getGauges (err, data) ->
      if err? or not data?
        callback err
      else
        gauges = []
        for g in data.gauges
          gauges.push
            title: g.title
            views: g.yesterday.views
            people: g.yesterday.people

        callback null, gauges

  getViewsForDate: (date, callback) ->
    @getGauges (err, data) ->
      if err? or not data?
        callback err
      else
        gauges = []
        for g in data.gauges
          for d in g.recent_days
            if d.date is date
              gauges.push
                title: g.title
                views: d.views
                people: d.people

        callback null, gauges

  getGauges: (callback) ->
    @robot.http("https://secure.gaug.es/gauges")
      .headers("X-Gauges-Token": @token)
      .get() (err, res, body) ->
        if res.statusCode is 200
          data = JSON.parse body
          callback null, data
        else if err?
          callback err
        else
          callback "Could not get gauges for today"


module.exports = (robot) ->

  robot.respond /gauges for (today|yesterday)/i, (msg) ->
    day = msg.match[1]
    robot.emit "gauges", { user: msg.user, for: day }

  robot.respond /gauges for (\d{4}-\d{2}-\d{2})/i, (msg) ->
    day = msg.match[1]
    robot.emit "gauges", { user: msg.user, for: 'data' , day: day }

  # handle gauges events, can be emited by other script
  robot.on "gauges", (data) ->
    gauges = new Gauges robot, process.env.HUBOT_GAUGES_TOKEN

    #handle a list of gauges
    handler = (err, list) ->
      if err?
        robot.send data.user, "#{err}"
      else
        for g in list
          robot.send data.user, "#{g.title}: Views #{g.views} People #{g.people}"

    switch data.for
      when "today"
        gauges.getViewsForToday handler

      when "yesterday"
        gauges.getViewsForYesterday handler

      when "data"
          gauges.getViewsForDate data.day, handler
