# Description
#   Simple axis visualization.
#
# Commands:
#   hubot scale <value> - Show a simple text scale.
#   hubot scale <locale> <value> - Show a simple text scale in specified locale - can be 'uk', 'nj', or 'uh'.

# Author:
#   pengwynn
#   ymendel
#   balevine

drawScale = (value, max = 10, locale = 'us') ->
  if value?
    locale = locale.replace(' ', '').toLowerCase()
    max = parseInt(max)
    pos = if value then parseInt(value) else 0
    pos ?= 0
    pos = Math.min(pos, max)
    pos = Math.max(pos, 0)
    switch locale
     when 'uh'
        textMin = "wut"
        textMax = "wat"
      when 'uk'
        textMin = "dreadful"
        textMax = "brilliant"
      when 'nj'
        textMin = "You think you're better than me?"
        textMax = "fuggedaboutit"
      else
        textMin = "horrible"
        textMax = "amazing"

    left = Array(pos).join("=")
    right = Array(max-pos+1).join("=")

    "[#{textMin}]#{left}X#{right}[#{textMax}]"

module.exports = (robot) ->
  robot.respond /scale(\s\w+)? (\d+)\/?(\d+)?/i, (msg) ->
    msg.send(drawScale(msg.match[2], msg.match[3], msg.match[1]))
