# Description:
#   Pub-Sub notification system for Hubot.
#   Subscribe rooms to various event notifications and publish them
#   via HTTP requests or chat messages.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SUBSCRIPTIONS_PASSWORD (optional)
#
# Commands:
#   hubot subscribe <event> - subscribes current room to event
#   hubot unsubscribe <event> - unsubscribes current room from event
#   hubot unsubscribe all events - unsubscribes current room from all events
#   hubot subscriptions - show subscriptions of current room
#   hubot all subscriptions - show all existing subscriptions
#   hubot publish <event> <data> - triggers event
#
# URLS:
#   GET /publish?event=<event>&data=<text>[&password=<password>]
#   POST /publish (Content-Type: application/json, {"password": "optional", "event": "event", "data": "text" })
#
# Author:
#   spajus

module.exports = (robot) ->

  url = require('url')
  querystring = require('querystring')

  subscriptions = (ev) ->
    subs = robot.brain.data.subscriptions ||= {}
    if ev
      subs[ev] ||= []
    else
      subs

  notify = (event, data) ->
    count = 0
    if event && subscriptions(event)
      for room in subscriptions(event)
        count += 1
        user = {}
        user.room = room
        robot.send user, "#{event}: #{data}"
    count

  persist = (subscriptions) ->
    robot.brain.data.subscriptions = subscriptions
    robot.brain.save()

  robot.respond /subscribe ([a-z0-9\-\.\:]+)$/i, (msg) ->
    ev = msg.match[1]
    subscriptions(ev).push msg.message.user.room
    persist subscriptions
    msg.send "Subscribed #{msg.message.user.room} to #{ev} events"

  robot.respond /unsubscribe ([a-z0-9\-\.\:]+)$/i, (msg) ->
    ev = msg.match[1]
    subs = subscriptions()
    subs[ev] ||= []
    if msg.message.user.room in subs[ev]
      index = subs[ev].indexOf msg.message.user.room
      subs[ev].splice(index, 1)
      persist subs
      msg.send "Unsubscribed #{msg.message.user.room} from #{ev} events"
    else
      msg.send "#{msg.message.user.room} was not subscribed to #{ev} events"

  robot.respond /unsubscribe all events$/i, (msg) ->
    count = 0
    subs = subscriptions()
    for ev of subs
      if msg.message.user.room in subs[ev]
        index = subs[ev].indexOf msg.message.user.room
        subs[ev].splice(index, 1)
        count += 1
    persist subs
    msg.send "Unsubscribed #{msg.message.user.room} from #{count} events"

  robot.respond /subscriptions$/i, (msg) ->
    count = 0
    for ev of subscriptions()
      if msg.message.user.room in subscriptions(ev)
        count += 1
        msg.send "#{ev} -> #{msg.message.user.room}"
    msg.send "Total subscriptions for #{msg.message.user.room}: #{count}"

  robot.respond /all subscriptions$/i, (msg) ->
    count = 0
    for ev of subscriptions()
      for room in subscriptions(ev)
        count += 1
        msg.send "#{ev} -> #{room}"
    msg.send "Total subscriptions: #{count}"

  robot.respond /publish ([a-z0-9\-\.\:]+) (.*)$/i, (msg) ->
    ev = msg.match[1]
    data = msg.match[2]
    count = notify(ev, data)
    msg.send "Notified #{count} rooms about #{ev}"

  robot.router.get "/publish", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    res.end('')
    return unless query.password == process.env.HUBOT_SUBSCRIPTIONS_PASSWORD
    notify(query.event, query.data)

  robot.router.post "/publish", (req, res) ->
    res.end('')
    data = req.body
    return unless data.password == process.env.HUBOT_SUBSCRIPTIONS_PASSWORD
    notify(data.event, data.data)

