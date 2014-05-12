# Description:
#   A better implementation of factoid support for your hubot.
#   Supports history (in case you need to revert a change), as
#   well as popularity and aliases and @mentions.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FACTOID_PREFIX - prefix character to use for retrieving a factoid
#   HUBOT_BASE_URL - URL of Hubot (ex. http://myhubothost.com:5555/)
#
# Commands:
#   hubot learn <factoid> = <details> - learn a new factoid
#   hubot learn <factoid> =~ s/expression/replace/gi - edit a factoid
#   hubot alias <factoid> = <factoid>
#   hubot forget <factoid> - forget a factoid
#   hubot factoids - get a link to the raw factoid data
#   !<factoid> - play back a factoid (! is the default prefix)
#
# Author:
#   therealklanni

factoids =
  set: (key, value, who) ->
    fact = factoids.get key

    if typeof fact is 'object'
      fact.history ?= []
      hist =
        date: Date()
        editor: who
        oldValue: fact.value
        newValue: value

      fact.history.push hist
      fact.value = value
      if fact.forgotten? then fact.forgotten = false
    else
      fact =
        value: value
        popularity: 0

    factoids.data[key.toLowerCase()] = fact
    "OK #{who}, #{key} is now #{value}"

  get: (key) ->
    fact = factoids.data?[key.toLowerCase()]
    alias = fact?.value?.match /^@([^@].+)$/i
    if alias?
      fact = factoids.get alias[1]
    fact

  forget: (key) ->
    fact = factoids.get key

    if fact
      fact.forgotten = true
      "OK, forgot #{key}"

module.exports = (robot) ->
  factoids.data ?= {}

  robot.brain.on "loaded", ->
    factoids.data = robot.brain.data.betterFactoids ?= {}

  robot.router.get "/hubot/factoids", (req, res) ->
    res.end JSON.stringify factoids.data, null, 2

  blip = '!' unless process.env.HUBOT_FACTOID_PREFIX

  robot.hear new RegExp("^#{blip}([\\w\\s-]{2,}\\w)( @(.+))?", 'i'), (msg) ->
    fact = factoids.get msg.match[1]
    to = msg.match[3]
    if not fact? or fact.forgotten
      msg.reply "Not a factoid"
    else
      fact.popularity++
      to ?= msg.message.user.name
      msg.send "@#{to}: #{fact.value}"

  robot.respond /learn (.{3,}) = (.+)/i, (msg) ->
    msg.send factoids.set msg.match[1], msg.match[2], msg.message.user.name

  robot.respond /learn (.{3,}) =~ s\/(.+)\/(.+)\/(.*)/i, (msg) ->
    key = msg.match[1]
    re = new RegExp(msg.match[2], msg.match[4])
    fact = factoids.get key
    value = fact.value.replace re, msg.match[3]

    msg.send factoids.set key, value, msg.message.user.name

  robot.respond /forget (.{3,})/i, (msg) ->
    forgot = factoids.forget msg.match[1]
    msg.reply "Not a factoid" unless forgot

  robot.respond /factoids/i, (msg) ->
    url = process.env.HUBOT_BASE_URL or "http://not-yet-set/"
    msg.reply "#{url.replace /\/$/, ''}/hubot/factoids"

  robot.respond /alias (.{3,}) = (.{3,})/i, (msg) ->
    who = msg.message.user.name
    alias = msg.match[1]
    target = msg.match[2]
    msg.send "OK #{who}, aliased #{alias} to #{target}" if factoids.set msg.match[1], "@#{msg.match[2]}", msg.message.user.name
