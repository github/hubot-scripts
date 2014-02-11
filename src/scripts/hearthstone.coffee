# Description:
#   Returns a Hearthstone cards's stats
#
# Dependencies:
#   None
#
# Commands:
#   @card name - Returns the card's stats: name - mana - race - type - attack/hlth - descr
#
# Author:
#   sylturner
#
getByName = (json, name) ->
  json.filter (card) ->
    card.name.toLowerCase() is name.toLowerCase()

module.exports = (robot) ->
  robot.hear /^@(.+)/, (msg) ->
    msg.http('https://raw.github.com/nckg/Hearthstone-Cards/master/hearthstone.json').get() (err, res, body) ->
      data = JSON.parse(body)
      found = getByName(data, msg.match[1])
      if found.length > 0
        msg.send "#{found[0].name} - Mana: #{found[0].mana} - Race: #{found[0].race} - Type: #{found[0].type} - Attack/Health: #{found[0].attack}/#{found[0].health} - Descr: #{found[0].descr}"
      else
        msg.send "I can't find that card"
