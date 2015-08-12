# Description
#   display queue info from rabbitmq
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_RABBITMQ_ROOT_URL
#   HUBOT_RABBITMQ_USER (default is 'guest')
#   HUBOT_RABBITMQ_PWD (default is 'guest')
#   HUBOT_RABBITMQ_VIRT_HOST (defaults to '/')
#
# Commands:
#   hubot rabbit nodes - display list of cluster nodes (name, uptime)
#   hubot rabbit vhosts - display list of vhosts
#   hubot rabbit queues - display list of queues (messages_ready, messages_unacknowledged, name)
#   hubot rabbit slow queues - display list of queues with messages.length > slow threshold
#   hubot set rabbit queues slow <threshold> - set slow queue threshold
#   hubot rabbit bindings <subscription> - display binding info for a subscription (source->destination (type) {args})
#
# Notes:
#
# Author:
#   kevwil, davidsulpy

url = process.env.HUBOT_RABBITMQ_ROOT_URL
user = process.env.HUBOT_RABBITMQ_USER ?= 'guest'
pwd = process.env.HUBOT_RABBITMQ_PWD ?= 'guest'
virt = process.env.HUBOT_RABBITMQ_VIRT_HOST ?= '%2F'
auth = 'Basic ' + new Buffer(user + ':' + pwd).toString('base64')

_queues = {}

dhm = (t) ->
  cd = 24 * 60 * 60 * 1000
  ch = 60 * 60 * 1000
  d = Math.floor(t / cd)
  h = '0' + Math.floor( (t - d * cd) / ch)
  m = '0' + Math.round( (t - d * cd - h * ch) / 60000)
  # [d, h.substr(-2), m.substr(-2)].join(':')
  "#{d}d,#{h.substr(-2)}h,#{m.substr(-2)}m"

# get_queues = (msg) ->
#   msg
#     .http("#{url}/api/queues")
#     .query(sort_reverse: 'messages')
#     .headers(Authorization: auth, Accept: 'application/json')
#     .get() (err, res, body) ->
#       if err
#         [err, null]
#       else
#         try
#           json = JSON.parse body
#           [null, json]
#         catch e
#           [e, null]



module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    if robot.brain.data.queues?
      _queues = robot.brain.data.queues

  robot.respond /rabbit nodes/i, (msg) ->
    results = []
    msg
      .http("#{url}/api/nodes")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send err
        else
          try
            json = JSON.parse body
            results.push "'#{node.name}' #{dhm(node.uptime)}" for node in json
            msg.send results.join '\n'
          catch e
            msg.send e

  robot.respond /rabbit queues/i, (msg) ->
    results = []
    msg
      .http("#{url}/api/queues")
      .query(sort_reverse: 'messages')
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send err
        else
          try
            json = JSON.parse body
            for queue in json
              results.push "#{queue.messages_ready} #{queue.messages_unacknowledged} #{queue.name}"
            if results?.length < 1
              msg.send 'no queues found'
            else
              msg.send results.join '\n'
          catch e
            msg.send e

  robot.respond /rabbit slow queues/i, (msg) ->
    results = []
    msg
      .http("#{url}/api/queues")
      .query(sort_reverse: 'messages')
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send err
        else
          try
            json = JSON.parse body
            for queue in json
              if queue.messages >= _queues.slow
                results.push "#{queue.messages_ready} #{queue.messages_unacknowledged} #{queue.name}"
            if results?.length < 1
              msg.send 'no slow queues found.'
            else
              msg.send results.join '\n'
          catch e
            msg.send e

  robot.respond /rabbit bindings (.*)/i, (msg) ->
    sub = msg.match[1]
    results = []
    msg
      .http("#{url}/api/queues/#{virt}/#{sub}/bindings")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send err
        else
          try
            json = JSON.parse body
            for binding in json
              args = []
              args.push "#{key}:#{value}" for key,value of binding.arguments
              params = "{#{args.join(',')}}"
              results.push "'#{binding.source}' -> '#{binding.destination}' (#{binding.destination_type}) #{params}"
            if results?.length < 1
              msg.send 'no bindings found.'
            msg.send results.join '\n'
          catch e
            msg.send e

  robot.respond /rabbit vhosts/i, (msg) ->
    results = []
    msg
      .http("#{url}/api/vhosts")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send err
        else
          try
            json = JSON.parse body
            results.push "'#{vhost.name}'" for vhost in json
            msg.send results.join '\n'
          catch e
            msg.send e
        
        
  robot.respond /set rabbit queues slow (\d*)/i, (msg) ->
    _queues.slow = msg.match[1]
    robot.brain.data.queues = _queues
    msg.send "Saved."
