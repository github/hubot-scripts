# Description:
#   Stores the brain in Amazon S3
#
# Dependencies:
#   "aws2js": "0.7.10"
#
# Configuration:
#   HUBOT_S3_BRAIN_ACCESS_KEY_ID
#   HUBOT_S3_BRAIN_SECRET_ACCESS_KEY
#   HUBOT_S3_BRAIN_BUCKET
#
# Commands:
#
# Notes:
#   It's highly recommended to use an IAM account explicitly for this purpose
#   https://console.aws.amazon.com/iam/home?
#   A sample S3 policy for a bucket named Hubot-Bucket would be
#   {
#      "Statement": [
#        {
#          "Action": [
#            "s3:DeleteObject",
#            "s3:DeleteObjectVersion",
#            "s3:GetObject",
#            "s3:GetObjectAcl",
#            "s3:GetObjectVersion",
#            "s3:GetObjectVersionAcl",
#            "s3:PutObject",
#            "s3:PutObjectAcl",
#            "s3:PutObjectVersionAcl"
#          ],
#          "Effect": "Allow",
#          "Resource": [
#            "arn:aws:s3:::Hubot-Bucket/brain-dump.json"
#          ]
#        }
#      ]
#    }
#
# Author:
#   Iristyle

util  = require 'util'
aws   = require 'aws2js'

# sets up hooks to persist the brain into redis.
module.exports = (robot) ->

  loaded            = false
  key               = process.env.HUBOT_S3_BRAIN_ACCESS_KEY_ID
  secret            = process.env.HUBOT_S3_BRAIN_SECRET_ACCESS_KEY
  bucket            = process.env.HUBOT_S3_BRAIN_BUCKET
  brain_dump_path   = "#{bucket}/brain-dump.json"

  if !key && !secret && !bucket
    throw new Error('S3 brain requires HUBOT_S3_BRAIN_ACCESS_KEY_ID, ' +
      'HUBOT_S3_BRAIN_SECRET_ACCESS_KEY and HUBOT_S3_BRAIN_BUCKET configured')

  s3 = aws.load('s3', key, secret)

  store_brain = (brain_data, callback) ->
    if !loaded
      robot.logger.debug 'Not saving to S3, because not loaded yet'
      return

    buffer = new Buffer(JSON.stringify(brain_data))
    headers =
      'Content-Type': 'application/json'

    s3.putBuffer brain_dump_path, buffer, 'private', headers, (err, response) ->
      if err
        robot.logger.error util.inspect(err)
      else if response
        robot.logger.debug "Saved brain to S3 path #{brain_dump_path}"

      if callback then callback(err, response)

  store_current_brain = () ->
    store_brain robot.brain.data

  # 30 minute timer based save to limit s3 PUT requests
  time = 30 * 60 * 1000
  intervalId = setInterval store_current_brain, time

  s3.get brain_dump_path, 'buffer', (err, response) ->
    # unfortunately S3 gives us a 403 if we have access denied OR
    # the file is simply missing, so no way of knowing if IAM policy is bad
    save_handler = (e, r) ->
      if e then throw new Error("Error contacting S3:\n#{util.inspect(e)}")

    # try to store an empty placeholder to see if IAM settings are valid
    if err then store_brain {}, save_handler

    if response && response.buffer
      robot.brain.mergeData JSON.parse(response.buffer.toString())

  robot.brain.on 'loaded', () ->
    loaded = true
    store_current_brain()

  robot.brain.on 'close', ->
    clearInterval intervalId
    store_current_brain()
