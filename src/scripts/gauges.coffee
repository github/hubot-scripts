# Allows Hubot to fetch statistics from Gaug.es
#
# gauges for (today|yesterday) - Get views/people from today or yesterday.
#
# gauges for YYYY-MM-DD - Get views/people for the specified date.
#
module.exports = (robot) ->

  robot.respond /gauges for (today|yesterday)/i, (msg) ->
    token = process.env.HUBOT_GAUGES_TOKEN
    day = msg.match[1]
    msg.http("https://secure.gaug.es/gauges")
      .headers("X-Gauges-Token": token)
      .get() (err, res, body) ->
        data = JSON.parse body
        for g in data.gauges
          msg.send "#{g.title}: Views - #{g[day].views}, People - #{g[day].people}"

  robot.respond /gauges for (\d{4}-\d{2}-\d{2})/i, (msg) ->
    token = process.env.HUBOT_GAUGES_TOKEN
    day = msg.match[1]
    msg.http("https://secure.gaug.es/gauges")
      .headers("X-Gauges-Token": token)
      .get() (err, res, body) ->
        data = JSON.parse body
        for g in data.gauges
          for d in g.recent_days
            if d.date is day
              msg.send "#{g.title}: Views - #{d.views}, People - #{d.people}"

