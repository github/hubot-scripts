# Description:
#   None
#
# Dependencies:
#   "redis": "0.8.4"
#
# Configuration:
#   REDISTOGO_URL or REDISCLOUD_URL or BOXEN_REDIS_URL
#
# Commands:
#   None
#
# Author:
#   atmos, jan0sch

Url   = require "url"
Redis = require "redis"

module.exports = (robot) ->
  info   = Url.parse process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL or process.env.BOXEN_REDIS_URL or 'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)

  robot.brain.setAutoSave false

  getData = ->
    client.get "hubot:storage", (err, reply) ->
      if err
        throw err
      else if reply
        robot.logger.info "Data for brain retrieved from Redis"
        robot.brain.mergeData JSON.parse(reply.toString())
      else
        robot.logger.info "Initializing new data for brain"
        robot.brain.mergeData {}

      robot.brain.setAutoSave true

  if info.auth
    client.auth info.auth.split(":")[1], (err) ->
      if err
        robot.logger.error "Failed to authenticate to Redis"
      else
        robot.logger.info "Successfully authenticated to Redis"
        getData()

  client.on "error", (err) ->
    robot.logger.error err

  client.on "connect", ->
    robot.logger.debug "Successfully connected to Redis"
    getData() if not info.auth

  robot.brain.on 'save', (data = {}) ->
    client.set 'hubot:storage', JSON.stringify data

  robot.brain.on 'close', ->
    client.quit()
