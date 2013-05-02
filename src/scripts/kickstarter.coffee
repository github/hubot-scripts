# Description:
#   Updates from KickStarter project
#
# Configuration:
#   KICKSTARTER_PROJECT
#   KICKSTARTER_INTERVAL
#
# Commands:
#   hubot kickstarter start - Start the kickstarter update feed
#   hubot kickstarter change <mins> - Change the interval of kickstarter updates
#   hubot kickstarter stop - Stop the kickstarter update feed
#
# Author:
#   pksunkara

module.exports = (robot) ->
  init = false
  timer = 0
  interval = parseInt(process.env.KICKSTARTER_INTERVAL || 5)

  previous =
    flag: false
    percent: 0
    pledged: 0

  robot.respond /kickstarter start/i, (msg) ->
    if not init
      init = true
      setTimer interval, msg
      msg.send "Started the kickstarter update feed"
    else
      msg.send "Its already running!"

  robot.respond /kickstarter stop/i, (msg) ->
    if init
      init = false
      clearTimeout timer
      msg.send "Stopped the kickstarter update feed"

  robot.respond /kickstarter change ([1-9][0-9]*)/i, (msg) ->
    clearTimeout timer
    interval = parseInt msg.match[1]
    setTimer interval, msg
    msg.send "Changed the kickstarter update interval"

  setTimer = (interval, msg) ->
    timer = setTimeout scrape, interval*60*1000, robot, (err, data) ->
      if not err and data
        setTimer interval, msg

        if not previous.flag
          previous =
            flag: true
            percent: data.percent
            pledged: data.pledged

          msg.send "#{currency(data.currency)} #{pledged(data.pledged)} from #{data.backers} backers (#{percent(data.percent)})"
        else
          if previous.pledged < data.pledged
            msg.send "#{currency(data.currency)} #{pledged(data.pledged)} from #{data.backers} backers (#{percent(data.percent)}) (#{changed(previous.pledged, data.pledged)})"

            if previous.percent < 1 and data.percent > 1
              msg.send "HURRAY! We are funded successfully! PARTY TIME EVERYONE!"

            previous.pledged = data.pledged
            previous.percent = data.percent
      else
        setTimer 0, msg

changed = (p, d) ->
  Math.round(d - p)

pledged = (p) ->
  Math.round(p).toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

percent = (t) ->
  "#{Math.round(t * 10000)/100} %"

currency = (c) ->
  if c is 'USD' then "$" else "£"

scrape = (robot, cb) ->
  robot.http("http://www.kickstarter.com/projects/#{process.env.KICKSTARTER_PROJECT}")
    .get() (err, res, body) ->
      if err then return cb err

      b = body.match /data-backers-count=\"([0-9]*)\"/
      p = body.match /data-pledged=\"([0-9]*.[0-9]*)\"/
      c = body.match /data-currency=\"([A-Z]{3})\"/
      t = body.match /data-percent-raised=\"([0-9]*.[0-9]*)\"/

      cb null,
        backers : b[1]
        pledged : p[1]
        currency: c[1]
        percent : t[1]
