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
  info   = Url.parse process.env.REDISTOGO_URL || process.env.BOXEN_REDIS_URL || 'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)

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
        robot.logger.info "Brain data retrieved from redis-brain storage"
        robot.brain.mergeData JSON.parse(reply.toString())
      else
        robot.logger.info "Initializing new redis-brain storage"
        robot.brain.mergeData {}

      robot.logger.info "Enabling brain auto-saving"
      robot.brain.setAutoSave true

  # Prevent autosaves until connect has occured
  robot.logger.info "Disabling brain auto-saving"
  robot.brain.setAutoSave false

  robot.brain.on 'save', (data = {}) ->
    robot.logger.debug "Saving brain data"
    client.set 'hubot:storage', JSON.stringify data

  robot.brain.on 'close', ->
    client.quit()
