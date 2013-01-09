# Description:
#   None
#
# Dependencies:
#   "redis": "0.7.2"
#
# Configuration:
#   REDISTOGO_URL
#
# Commands:
#   None
#
# Author:
#   atmos

Url   = require "url"
Redis = require "redis"

# sets up hooks to persist the brain into redis.
module.exports = (robot) ->
  info   = Url.parse process.env.REDISTOGO_URL || 'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)
  loaded = false

  if info.auth
    client.auth info.auth.split(":")[1]

  client.on "error", (err) ->
    robot.logger.error err

  client.on "connect", ->
    robot.logger.debug "Successfully connected to Redis"

    client.get "hubot:storage", (err, reply) ->
      if err
        throw err
      else if reply
        robot.brain.mergeData JSON.parse(reply.toString())

  robot.brain.on 'loaded', () ->
    loaded = true
  robot.brain.on 'save', (data) ->
    if not loaded
      robot.logger.debug "Not saving, because not loaded yet"
      return
    client.set 'hubot:storage', JSON.stringify data

  robot.brain.on 'close', ->
    client.quit()
