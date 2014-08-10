# Description
#  Report build status from ThoughtWorks' Go.
#
# Dependencies:
#  "feedparser": "~0.19.x"
#  "request": ""
#  "underscore": ""
#
# Configuration:
#  HUBOT_GO_POLL_INTERVAL = Interval in seconds to poll Feeds API (optional)
#  HUBOT_GO_STATUS_ROOM= Room to receive build status updates
#  HUBOT_GO_SERVER_HOST= Host and port eg - localhost:8153
#  HUBOT_GO_SERVER_USERNAME= Username to access Feeds API
#  HUBOT_GO_SERVER_PASSWORD= Password
#  go-pipelines.json - JSON configuration for tracked Pipelines.
#    Located at Hubot root.
#    Specifies Pipelines and Stages to track and also the status.
#    Example:
#    {
#      "Pipeline1": {
#       "Stage": ["passed", "failed"]
#      },
#      "Pipeline2": {
#        "Stage": ["failed"]
#      }
#    }
# Commands:
#  hubot go pipelines - Shows the pipeline configuration for debug
#
# Author:
#   manojlds

FeedParser = require('feedparser')
request = require('request')
util = require('util')
_ = require('underscore')
fs = require('fs')

FEED_FETCH_INTERVAL_IN_SECONDS = process.env.HUBOT_GO_POLL_INTERVAL or 60
ROOM = process.env.HUBOT_GO_STATUS_ROOM
GO_SERVER = process.env.HUBOT_GO_SERVER_HOST
GO_USERNAME = process.env.HUBOT_GO_SERVER_USERNAME
GO_PASSWORD = process.env.HUBOT_GO_SERVER_PASSWORD
GO_FEED_ENDPOINT = "http://#{GO_USERNAME}:#{GO_PASSWORD}@#{GO_SERVER}/go/api/pipelines/%s/stages.xml"
PIPELINES = JSON.parse(fs.readFileSync('go-pipelines.json', 'utf8'))

Robot = {}
user = {}
user.room = ROOM

sendMessage = (item) ->
  msg = item.title + " " + item.link
  Robot.send user, msg

processTrackedStage = (stage, pipeline, stageName) ->
  storageKey = "lastupdate::#{pipeline}::#{stageName}"
  storedDate = Robot.brain.data[storageKey]

  if !storedDate?
    storedDate = stage.date
    Robot.brain.data[storageKey] = storedDate

  trackedStatuses = PIPELINES[pipeline][stageName]
  isStatusTracked = _.any(stage.categories, (category) ->
    category in trackedStatuses
  )

  return if !isStatusTracked

  if storedDate < stage.date
    sendMessage stage
    storedDate = stage.date

  Robot.brain.data[storageKey] = storedDate

processStage = (stage, pipeline) ->
  Object.keys(PIPELINES[pipeline]).forEach (s) ->
    processTrackedStage stage, pipeline, s if stage.title.indexOf(s) > -1

fetch = (pipeline) ->
  link = util.format GO_FEED_ENDPOINT, pipeline
  req = request(link)
  feedparser = req.pipe(new FeedParser())
    .on('error', (error) ->
      console.log "error: #{error}"
    )
    .on('readable', () ->
      stream = this
      processStage stage, pipeline while stage = stream.read()
    )

start = () ->
  Object.keys(PIPELINES).forEach (pipeline) ->
    fetch pipeline

module.exports = (robot) ->
  Robot = robot
  setInterval () ->
    start()
  , FEED_FETCH_INTERVAL_IN_SECONDS * 1000

  Robot.respond /go pipelines/i, (msg) ->
    msg.reply JSON.stringify(PIPELINES)
