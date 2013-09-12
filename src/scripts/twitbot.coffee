# Description:
#   Track hashtags and mentions, for fun.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   #<hashtag> - increment hashtag counter
#   @<mention> - increment mention counter
#   hubot mentions - list the most popular mentions
#   hubot hashtags - list the most popular hashtags
#   hubot twitbot reset - reset twitbot data
#
# Author:
#   robhurring

class Twitbot
  constructor: (@robot) ->
    @reset()
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.twitbot
        @cache = @robot.brain.data.twitbot

  reset: ->
    @cache =
      mentions: {}
      hashtags: {}

  add_mention: (user) ->
    user = user.trim().toLowerCase()
    @cache.mentions[user] ?= 0
    @cache.mentions[user] += 1
    @robot.brain.data.twitbot = @cache

  top_mentions: (n = 10) ->
    sorted = @sort('mentions')
    sorted.slice(0, n)

  add_hashtag: (hashtag) ->
    hashtag = hashtag.trim().toLowerCase()
    @cache.hashtags[hashtag] ?= 0
    @cache.hashtags[hashtag] += 1
    @robot.brain.data.twitbot = @cache

  top_hashtags: (n = 10) ->
    sorted = @sort('hashtags')
    sorted.slice(0, n)

  sort: (bucket) ->
    s = []
    for key, val of @cache[bucket]
      s.push({ data: key, count: val })
    s.sort (a, b) -> b.count - a.count

module.exports = (robot) ->
  twitbot = new Twitbot robot

  robot.hear /(^|\s)@([A-Za-z0-9_]+)/g, (msg) ->
    console.log msg.match
    for mention in msg.match
      twitbot.add_mention mention

  robot.hear /(^|\s)#(\w+)/g, (msg) ->
    for hashtag in msg.match
      twitbot.add_hashtag hashtag

  robot.respond /twitbot reset/i, (msg) ->
    twitbot.reset()
    msg.send "Ok. Twitbot is reset."

  robot.respond /mentions$/i, (msg) ->
    _output = []
    for mention in twitbot.top_mentions()
      _output.push "#{mention.data} has #{mention.count} mentions"

    if _output.length
      msg.send _output.join("\n")
    else
      msg.send "There are no mentions right now"

  robot.respond /hashtags$/i, (msg) ->
    _output = []
    for hashtag in twitbot.top_hashtags()
      _output.push "#{hashtag.data} was used #{hashtag.count} times"

    if _output.length
      msg.send _output.join("\n")
    else
      msg.send "There are no hashtags right now"
