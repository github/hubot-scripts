# Description:
#   None
#
# Dependencies:
#   "redis": "0.7.2"
#
# Configuration:
#   REDISTOGO_URL
#   HUBOT_BRAIN_AUTOSAVE=true                  -Enables Auto Saving of the redis brain
#   HUBOT_BRAIN_AUTOSAVE_INTERVAL=<seconds>    -Sets the Auto Save interval to <seconds> seconds, default is 5s
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
  info = Url.parse process.env.REDISTOGO_URL || 'redis://localhost:6379'
  autoSave = process.env.HUBOT_BRAIN_AUTOSAVE || true
  autoSaveInterval = process.env.HUBOT_BRAIN_AUTOSAVE_INTERVAL || false
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

      # Re-enable autosaves if set by config
      if autoSave
        robot.logger.info "Enabling brain auto-saving"
        robot.brain.setAutoSave true

        # Set autosave interval if supplied by config
        if autoSaveInterval
          robot.logger.info "Setting brain auto-saving interval to " + autoSaveInterval + "s"
          robot.brain.resetSaveInterval parseInt autoSaveInterval

  # Prevent autosaves until connect has occured
  robot.logger.info "Disabling brain auto-saving"
  robot.brain.setAutoSave false

  robot.brain.on 'save', (data = {}) ->
    robot.logger.debug "Saving brain data"
    client.set 'hubot:storage', JSON.stringify data

  robot.brain.on 'close', ->
    client.quit()
