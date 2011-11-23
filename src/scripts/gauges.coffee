# Allows Hubot to fetch statistics from Gaug.es
#
# gauges for (today|yesterday) - Get views/people from today or yesterday.
#
# gauges for YYYY-MM-DD - Get views/people for the specified date.
#

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
    gauges = new Gauges robot, process.env.HUBOT_GAUGES_TOKEN
    day = msg.match[1]

    switch day
      when "today"
        gauges.getViewsForToday (err, gauges) ->
          if err?
            msg.send "#{err}"
          else
            for g in gauges
              msg.send "#{g.title}: Views #{g.views}, People #{g.people}"

      when "yesterday"
        gauges.getViewsForYesterday (err, gauges) ->
          if err?
            msg.send "#{err}"
          else
            for g in gauges
              msg.send "#{g.title}: Views #{g.views} People #{g.people}"

  robot.respond /gauges for (\d{4}-\d{2}-\d{2})/i, (msg) ->
    gauges = new Gauges robot, process.env.HUBOT_GAUGES_TOKEN
    day = msg.match[1]

    gauges.getViewsForDate day, (err, gauges) ->
      if err?
        msg.send "#{err}"
      else
        for g in gauges
          msg.send "#{g.title}: Views #{g.views} People #{g.people}"
