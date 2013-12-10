# Description:
#   Post a sound with sound player on Hall's room
#
# Configuration
#   HUBOT_HALL_ROOMS - rooms' ids separated by commas
#   HUBOT_HALL_ROOM_TOKENS - tokens for each room id separated by commas
#
#   Caution: the HUBOT_HALL_ROOMS and HUBOT_HALL_ROOMS_TOKENS means that
#   this script waits for:
#   HUBOT_HALL_ROOMS[i] is room id and HUBOT_HALL_ROOM_TOKENS[i] is token for room id indexed by i
#
#   To get room id just go to Hall's room like https://hall.com/rooms/<room_id>
#   To get token for some room just go to https://hall.com/docs/integrations/generic/
#   You must be the owner of the room to get an API token
#
# Commands:
#   <hubot> record sound <sound_name> <sound_link>
#   <hubot> delete sound <sound_name>
#   <hubot> delete all sounds
#   <hubot> list sounds
#   <hubot> sound me <sound_name>
#
# Author:
#   @fernandodev - https://github.com/fernandodev
#

QS = require 'querystring'
module.exports = (robot) ->
  auth = {}
  room_ids = process.env.HUBOT_HALL_ROOMS.split(',')
  tokens = process.env.HUBOT_HALL_ROOM_TOKENS.split(',')
  auth[room_ids[i]] = token for token, i in tokens

  robot.respond /record sound\ (.*)?\ (.*)?/i, (msg) ->
    robot.brain.data.sounds ?= {}
    key = msg.match[1]
    link = msg.match[2]
    robot.brain.data.sounds[key] = link
    msg.send "sound #{key} is #{link}."

  robot.respond /delete sound\ (.*)?/i, (msg) ->
    robot.brain.data.sounds ?= {}
    key = msg.match[1]
    delete robot.brain.data.sounds[key]
    msg.send "sound #{key} deleted."

  robot.respond /delete all sounds/i, (msg) ->
    robot.brain.data.sounds = {}
    msg.send "All sounds deleted."

  robot.respond /list sounds/i, (msg) ->
    robot.brain.data.sounds ?= {}
    sounds = robot.brain.data.sounds
    msg.send "no sounds recorded." if Object.keys(sounds).length == 0
    msg.send "#{key} ~> #{sounds[key]}" for key of sounds

  robot.respond /sound me\ (.*)?/i, (msg) ->
    robot.brain.data.sounds ?= {}
    key = msg.match[1]
    sounds = robot.brain.data.sounds
    if(key)
      speakIt msg, key, sounds[key] if sounds[key]
      msg.send "no sounds named #{key}." unless sounds[key]
  speakIt = (msg, name, link) ->
    token = auth[msg.message.user.room_id]
    if(token)
      data = QS.stringify({'title': "#{name}", 'picture':"http://imageshack.com/a/img31/9652/979g.png", 'message':"<audio controls><source src=\"#{link}\" type=\"audio/mpeg\">Your browser doesn't support it</audio>"})
      msg.http("https://hall.com/api/1/services/generic/#{token}")
        .post(data)
    else
      msg.send "Please set the HUBOT_HALL_ROOMS and HUBOT_HALL_ROOM_TOKENS environment variable."

