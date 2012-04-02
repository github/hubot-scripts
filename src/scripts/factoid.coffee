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

  handleFactoid: (text) ->
    if match = /^~(.+) is (.+)/i.exec text
      this.add match[1], match[2]
    else if match = /^~(.+)/i.exec text
      this.get match[1]

module.exports = (robot) ->
  factoids = new Factoids robot

  robot.hear /^~(.+)/i, (msg) ->
    msg.reply factoids.handleFactoid msg.message.text
