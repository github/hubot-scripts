# Description:
#   Replaces default `redis-brain` with MongoDB one. Useful
#   to those who wants to have persistence on completely free
#   Heroku account.
#
# Dependencies:
#   "mongodb": "*"
#
# Configuration:
#   MONGOLAB_URI
#
# Commands:
#   None
#
# Author:
#   juancoen, darvin

MongoClient = require('mongodb').MongoClient

encodeKeys = (obj) ->
  return obj if typeof obj isnt 'object'
  for key, value of obj
    if obj.hasOwnProperty key
      obj[key.replace(/\./g, ":::")] = encodeKeys(obj[key])
      delete obj[key] if (key.indexOf(".") > -1)
  obj

decodeKeys = (obj) ->
  return obj if typeof obj isnt 'object'
  for key, value of obj
    if obj.hasOwnProperty key
      obj[key.replace(/:::/g, ".")] = encodeKeys(obj[key])
      delete obj[key] if (key.indexOf(":::") > -1)
  obj

module.exports = (robot) ->
  mongoUrl   = process.env.MONGOLAB_URI 

  MongoClient.connect mongoUrl, (err, db) ->
    if err?
      throw err
    else
      robot.logger.debug "Successfully connected to Mongo"

      db.createCollection 'storage', (err, collection) ->
        collection.findOne {}, (err, document) ->
          if err?
            throw err
          else if document
            document = decodeKeys document
            robot.brain.mergeData document

      robot.brain.on 'save', (data) ->
        db.collection 'storage', (err, collection) ->
          # https://github.com/christkv/node-mongodb-native/blob/master/lib/mongodb/collection.js#L373
          # update(selector, document, options, callback)
          data = encodeKeys data
          opts =
            safe: true
            upsert: true
          collection.update {}, data, opts, (err) ->
            throw err if err?

      robot.brain.on 'close', ->
        db.close()

