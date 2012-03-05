class Factoids
  constructor: (@robot) ->
    @robot.brain.on 'loaded', =>
      @cache = @robot.brain.data.factoids
      @cache = {} unless @cache

  add: (key, val) ->
    @cache[key] = val
    @robot.brain.data.factoids = @cache
    "OK."

  get: (key) ->
    if @cache[key]
      @cache[key]
    else
      "No factoid for #{key}"


module.exports = (robot) ->
  factoids = new Factoids robot

  robot.hear /^~(.+) is (.+)/i, (msg) ->
    result = factoids.add msg.match[1], msg.match[2]
    msg.reply result

  robot.hear /^~(.+)/i, (msg) ->
    key = msg.match[1]
    # don't return factoid if we're adding a factoid.
    if /is .+/.exec key
      return
    result = factoids.get key
    msg.reply result
