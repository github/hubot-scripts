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
#


Url   = require "url"
MongoClient = require('mongodb').MongoClient

# sets up hooks to persist the brain into redis.
module.exports = (robot) ->
  mongoUrl   = process.env.MONGOLAB_URI 
  # define mongo server and client for hubot database.
  console.error "Trying to connect to #{mongoUrl}"
  #open a connection
  MongoClient.connect mongoUrl, (err, db) ->
    if err
      throw err
    else if db
      console.error "Connected to mongo: #{mongoUrl}"
      # create or retrieve the collection "storage"
      db.createCollection "storage", (err, collection) ->
        #retrieve the one object from the database collection
        collection.findOne {}, (err, doc) ->
          # if an error ocurs, throw an exception
          if err
            throw err
          else if doc
            # else, merge the document into the robot brain.
            robot.brain.mergeData doc

      # listen to the "save" event of the robot's brain.
      robot.brain.on 'save', (data) ->
        # retrieve the collection storage.
        db.collection 'storage', (err, collection) ->
          # remove the object from the database.
          collection.remove {}, (err) ->
            if err
              throw err
            else
              # save the new data provided by the robot brain.
              collection.save data, (err) ->
                if err
                  throw err

      # listen to the "close" event of the robot's brain.
      robot.brain.on 'close', ->
        # close the connection
        db.close()
