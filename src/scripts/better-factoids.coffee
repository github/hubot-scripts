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
      if fact.disabled? then fact.disabled = false
    else
      fact =
        value: value
        popularity: 0

    factoids.data[key] = fact
    "OK #{who}, #{key} is now #{value}"

  get: (key) ->
    factoids.data?[key]

  forget: (key) ->
    fact = factoids.get key

    if fact
      fact.disabled = true
      "OK, forgot #{key}"


module.exports = (robot) ->
  factoids.data = robot.brain.data.betterFactoids ?= {}

  robot.router.get "/hubot/factoids", (req, res) ->
    res.end JSON.stringify factoids.data, null, 2

  blip = '!' unless process.env.HUBOT_FACTOID_PREFIX

  robot.hear new RegExp("^#{blip}(.{3,})", 'i'), (msg) ->
    fact = factoids.get msg.match[1]
    fact.popularity++
    msg.reply fact.value unless fact.disabled

  robot.respond /learn (.{3,}) = (.+)/i, (msg) ->
    msg.reply factoids.set msg.match[1], msg.match[2], msg.message.user.name

  robot.respond /learn (.{3,}) =~ s\/(.+)\/(.+)\/(.+)/i, (msg) ->
    key = msg.match[1]
    re = new RegExp(msg.match[2], msg.match[4])
    fact = factoids.get key
    value = fact.value.replace re, msg.match[3]

    msg.reply factoids.set key, value, msg.message.user.name

  robot.respond /forget (.{3,})/i, (msg) ->
    forgot = factoids.forget msg.match[1]
    msg.reply "Not a factoid" unless forgot
