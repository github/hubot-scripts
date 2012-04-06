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
    @cache[key] or "No factoid for #{key}"

  tell: (person, key) ->
    factoid = this.get key
    if @cache[key]
      "#{person}, #{key} is #{factoid}"
    else
      factoid

  handleFactoid: (text) ->
    if match = /^~(.+) is (.+)/i.exec text
      this.add match[1], match[2]
    else if match = (/^~tell (.+) about (.+)/i.exec text) or (/^~~(.+) (.+)/.exec text)
      this.tell match[1], match[2]
    else if match = /^~(.+)/i.exec text
      this.get match[1]

module.exports = (robot) ->
  factoids = new Factoids robot

  robot.hear /^~(.+)/i, (msg) ->
    msg.reply factoids.handleFactoid msg.message.text
