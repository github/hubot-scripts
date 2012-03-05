factoids = {}

module.exports = (robot) ->
  
  robot.hear /^~(.+) is (.+)/i, (msg) ->
    factoids[msg.match[1]] = msg.match[2]
    msg.reply "OK."

  robot.hear /^~(.+)/i, (msg) ->
    key = msg.match[1]
    # don't return factoid if we're adding a factoid.
    if /is .+/.exec key
      return
    if factoids[key]
      msg.reply factoids[key]
    else
      msg.reply "No factoid for #{key}."
