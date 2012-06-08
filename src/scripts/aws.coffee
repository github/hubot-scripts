# Queries for the status of AWS services
#
# hubot sqs status - Returns the status of SQS queues.
#

# Environment variables:
#   HUBOT_AWS_ACCESS_KEY_ID     - The Amazon access key id
#   HUBOT_AWS_SECRET_ACCESS_KEY - The Amazon secret key for the given id
#
#
# package.json needs to have "aws2js":"0.6.12" and "moment":"1.6.2"
#
# It's highly recommended to use a read-only IAM account for this purpose
# https://console.aws.amazon.com/iam/home?#
#
# SQS - requires ListQueues, GetQueueAttributes and ReceiveMessage

key = process.env.HUBOT_AWS_ACCESS_KEY_ID
secret = process.env.HUBOT_AWS_SECRET_ACCESS_KEY

moment = require 'moment'
aws = require 'aws2js'
sqs = aws
  .load('sqs', key, secret)
  .setApiVersion('2011-10-01')

module.exports = (robot) ->
  robot.respond /(^|\W)sqs status(\z|\W|$)/i, (msg) ->

    sqs.request 'ListQueues', {}, (error, queues) ->
      if error?
        msg.send 'Failed to list queues'
        return

      queues.ListQueuesResult.QueueUrl.forEach (url) ->

        url = url['#']
        name = url.split '/'
        name = name[name.length - 1]
        path = url.replace 'https://queue.amazonaws.com', ''

        queue =
          Version: '2011-10-01'
          AttributeName: ['All']

        sqs.setQueue(path + '/')
        .request 'GetQueueAttributes', queue, (error, attributes) ->
          if error?
            msg.send "Can't read queue attributes [#{name}] (path #{path})" +
              " - #{url} - #{error}"
            return

          info = attributes.GetQueueAttributesResult.Attribute
          for index, attr of info
            switch attr.Name
              when 'ApproximateNumberOfMessages' \
                then msgCount = attr.Value
              when 'ApproximateNumberOfMessagesNotVisible' \
                then inFlight = attr.Value

          queue.MaxNumberOfMessages = 1
          queue.VisibilityTimeout = 0

          sqs.setQueue(path + '/')
          .request 'ReceiveMessage', queue, (error, result) ->

            queueDesc = "[SQS: #{name}] - [#{msgCount}] total msgs" +
              " / [#{inFlight}] in flight"
            if error?
              timestamp = "unavailable - #{error}"
            else
              sqsmsg = result.ReceiveMessageResult.Message
              if sqsmsg? and sqsmsg.Attribute?
                timestamp = (att for att in sqsmsg.Attribute \
                  when att.Name == 'SentTimestamp')
                timestamp = (moment parseFloat timestamp[0].Value)
                  .format 'ddd, L LT'
              else
                timestamp = 'none available'

            msg.send "#{queueDesc} / oldest msg ~[#{timestamp}] / #{url}"
