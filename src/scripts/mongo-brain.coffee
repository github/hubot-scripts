# Description:
#  Enhances hubot-brain with MongoDB. Useful for Heroku accounts that want
#  better persistance. Falls back to memory brain if Mongo connection fails
#  for local testing.
#
# Dependencies:
#   "mongodb": ">= 1.2.0"
#
# Configuration:
#   MONGODB_USERNAME
#   MONGODB_PASSWORD
#   MONGODB_HOST
#   MONGODB_PORT
#   MONGODB_DB
#
# Commands:
#   None
#
# Author:
#   ajacksified, maxbeatty

Util = require "util"
mongodb = require "mongodb"
Server = mongodb.Server
Collection = mongodb.Collection
Db = mongodb.Db

module.exports = (robot) ->
  user = process.env.MONGODB_USERNAME || "admin"
  pass = process.env.MONGODB_PASSWORD || "password"
  host = process.env.MONGODB_HOST || "localhost"
  port = process.env.MONGODB_PORT || "27017"
  dbname = process.env.MONGODB_DB || "hubot"

  error = (err) ->
    console.log "==MONGO BRAIN UNAVAILABLE==\n==SWITCHING TO MEMORY BRAIN=="
    console.log err

  server = new Server host, port, {}
  db = new Db dbname, server, { w: 1, native_parser: true }

  db.open (err, client) ->
    return error err if err

    robot.logger.debug 'Successfully opened connection to mongo'

    db.authenticate user, pass, (err, success) ->
      return error err if err

      robot.logger.debug 'Successfully authenticated with mongo'

      collection = new Collection client, 'hubot_storage'

      collection.find().limit(1).toArray (err, results) ->
        return error err if err

        robot.logger.debug 'Successfully queried mongo'
        robot.logger.debug Util.inspect(results, false, 4)

        if results.length > 0
          robot.brain.data = results[0]
          robot.brain.emit 'loaded', results[0]
        else
          robot.logger.debug 'No results found'

      robot.brain.on 'save', (data) ->
        robot.logger.debug 'Save event caught by mongo'
        robot.logger.debug Util.inspect(robot.brain.data, false, 4)

        collection.save robot.brain.data, (err) ->
          console.warn err if err?
