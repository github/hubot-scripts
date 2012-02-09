Url   = require "url"
Redis = require "redis"

# sets up hooks to persist the brain into redis.
module.exports = (robot) ->
  info   = Url.parse process.env.REDISTOGO_URL || 'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)

  if info.auth
    client.auth info.auth.split(":")[1]

  client.on "error", (err) ->
    robot.logger.error err

  client.on "connect", ->
    robot.logger.info "Successfully connected to Redis"

    client.get "hubot:storage", (err, reply) ->
      if err
        throw err
      else if reply
        robot.brain.mergeData JSON.parse(reply.toString())

  robot.brain.on 'save', (data) ->
    client.set 'hubot:storage', JSON.stringify data

  robot.brain.on 'close', ->
    client.quit()
