# Description:
#   Sensu API hubot client
#
# Dependencies:
#   "moment": ">=1.6.0"
#
# Configuration:
#   HUBOT_SENSU_API_UR - URL for the sensu api service.  http://sensu.yourdomain.com:4567
#   HUBOT_SENSU_DOMAIN - Domain to force on all clients.  Not used if blank/unset
#
# Commands:
#   hubot sensu info - show sensu api info
#   hubot sensu stashes - show contents of the sensu stash
#   hubot silence <client>[/service] [for \d+[unit]] - silence an alert for an optional period of time (default 1h)
#   hubot remove sensu stash <stash> - remove a stash from sensu
#   hubot sensu clients - show all clients
#   hubot sensu client <client>[ history] - show a specific client['s history]
#   hubot remove sensu client <client> - remove a client from sensu
#   hubot sensu events[ for <client>] - show all events or for a specific client
#   hubot resolve sensu event <client>/<service> - resolve a sensu event
#
# Notes:
#   Requires Sensu >= 0.12 because of expire parameter on stashes and updated /resolve and /request endpoints
#   Checks endpoint not implemented (http://docs.sensuapp.org/0.12/api/checks.html) -- also note /check/request is deprecated in favor of /request
#   Aggregates endpoint not implemented (http://docs.sensuapp.org/0.12/api/aggregates.html)
#
# Author:
#   Justin Lambert - jlambert121
#

moment = require('moment')

module.exports = (robot) ->

######################
#### Info methods ####
######################
  robot.respond /sensu info/i, (msg) ->
    msg.http(process.env.HUBOT_SENSU_API_URL + '/info')
      .get() (err, res, body) ->
        if res.statusCode == 200
          result = JSON.parse(body)
          message = 'Sensu version: ' + result['sensu']['version']
          message = message + '\nRabbitMQ: ' + result['rabbitmq']['connected'] + ', redis: ' + result['redis']['connected']
          message = message + '\nRabbitMQ keepalives (messages/consumers): (' + result['rabbitmq']['keepalives']['messages'] + '/' + result['rabbitmq']['keepalives']['consumers'] + ')'
          message = message + '\nRabbitMQ results (messages/consumers):' + result['rabbitmq']['results']['messages'] + '/' + result['rabbitmq']['results']['consumers'] + ')'
          msg.send message
        else
          msg.send "An error occurred retrieving sensu info"


#######################
#### Stash methods ####
#######################
  robot.respond /sensu stashes/i, (msg) ->
    msg.http(process.env.HUBOT_SENSU_API_URL + '/stashes')
      .get() (err, res, body) ->
        results = JSON.parse(body)
        output = []
        for result,value of results
          console.log value
          message = value['path'] + ' added on ' + moment.unix(value['content']['timestamp']).format('HH:MM M/D/YY')
          if value['content']['by']
            message = message + ' by ' + value['content']['by']
          if value['expire'] and value['expire'] > 0
            message = message + ', expires in ' + value['expire'] + ' seconds'
          output.push message
        msg.send output.sort().join('\n')

  robot.respond /silence ([^\s\/]*)(?:\/)?([^\s]*)?(?: for (\d+)(\w))?/i, (msg) ->
    # msg.match[1] = client
    # msg.match[2] = event (optional)
    # msg.match[3] = duration (optional)
    # msg.match[4] = units (required if duration)

    client = addClientDomain(msg.match[1])

    if msg.match[2]
      path = client + '/' + msg.match[2]
    else
      path = client

    duration = msg.match[3]
    if msg.match[4]
      unit = msg.match[4]
      switch unit
        when 's'
          expiration = duration
        when 'm'
          expiration = duration * 60

        when 'h'
          expiration = duration * 3600
        when 'd'
          expiration = duration * 24 * 3600
        else
          msg.send 'Unknown duration (' + unit + ').  I know s (seconds), m (minutes), h (hours), and d (days)'
          return
      human_d = duration + unit
    else
      expiration = 3600
      human_d = '1h'

    data = {}
    data['content'] = {}
    data['content']['timestamp'] = moment().unix()
    data['content']['by'] = msg.message.user.name
    data['expire'] = expiration
    data['path'] = 'silence/' + path

    msg.http(process.env.HUBOT_SENSU_API_URL + '/stashes')
      .post(JSON.stringify(data)) (err, res, body) ->
        if res.statusCode == 201
          msg.send path + ' silenced for ' + human_d
        else if res.statusCode == 400
          msg.send 'API returned malformed error for path silence/' + path + '\ndata: ' + JSON.stringify(data)
        else
          msg.send 'API returned an error for path silence/' + path + '\ndata: ' + JSON.stringify(data)

  robot.respond /remove sensu stash (.*)/i, (msg) ->

    stash = msg.match[1]
    unless stash.match /^silence\//
      stash = 'silence/' + stash

    # If it is only a hostname, verify domain name
    unless stash.match /^silence\/(.*)\//
      stash = addClientDomain(stash)

    msg.http(process.env.HUBOT_SENSU_API_URL + '/stashes/' + stash)
      .delete() (err, res, body) ->
        if res.statusCode == 204
          msg.send stash + ' removed'
        else if res.statusCode == 404
          msg.send stash + ' not found'
        else
          msg.send 'API returned an error removing ' + stash

########################
#### Client methods ####
########################
  robot.respond /sensu clients/i, (msg) ->
    msg.http(process.env.HUBOT_SENSU_API_URL + '/clients')
      .get() (err, res, body) ->
        results = JSON.parse(body)
        output = []
        for result,value of results
          output.push value['name'] + ' (' + value['address'] + ') subscriptions: ' + value['subscriptions'].sort().join(', ')

        if output.length == 0
          msg.send 'No clients'
        else
          msg.send output.sort().join('\n')

  robot.respond /sensu client (.*)( history)/i, (msg) ->
    client = addClientDomain(msg.match[1])

    msg.http(process.env.HUBOT_SENSU_API_URL + '/clients/' + client + '/history')
      .get() (err, res, body) ->
        if res.statusCode == 200
          results = JSON.parse(body)
          output = []
          for result,value of results
            output.push value['check'] + ' (last execution: ' + moment.unix(value['last_execution']).format('HH:MM M/D/YY') + ') history: ' + value['history'].join(', ')

          if output.length == 0
            msg.send 'No history found for ' + client
          else
            message = 'History for ' + client
            message = message + output.sort().join('\n')
            msg.send message
        else if res.statusCode == 404
          msg.send client + ' not found'
        else
          msg.send 'An error occurred looking up ' + client + '\'s history'


  robot.respond /sensu client (.*)/i, (msg) ->
    client = addClientDomain(msg.match[1])

    msg.http(process.env.HUBOT_SENSU_API_URL + '/clients/' + client)
      .get() (err, res, body) ->
        if res.statusCode == 200
          result = JSON.parse(body)
          msg.send result['name'] + ' (' + result['address'] + ') subscriptions: ' + result['subscriptions'].sort().join(', ')
        else if res.statusCode == 404
          msg.send client + ' not found'
        else
          msg.send 'An error occurred looking up ' + client


  robot.respond /remove sensu client (.*)/i, (msg) ->
    client= addClientDomain(msg.match[1])

    msg.http(process.env.HUBOT_SENSU_API_URL + '/clients/' + client)
      .delete() (err, res, body) ->
        if res.statusCode == 202
          msg.send client + ' removed'
        else if res.statusCode == 404
          msg.send client + ' not found'
        else
          msg.send 'API returned an error removing ' + client

#######################
#### Event methods ####
#######################
  robot.respond /sensu events(?: for (.*))?/i, (msg) ->
    if msg.match[1]
      client = '/' + addClientDomain(msg.match[1])
    else
      client = ''

    msg.http(process.env.HUBOT_SENSU_API_URL + '/events' + client)
      .get() (err, res, body) ->
        results = JSON.parse(body)
        output = []
        for result,value of results
          if value['flapping']
            flapping = ', flapping'
          else
            flapping = ''
          output.push value['client'] + ' (' + value['check'] + flapping + ') - ' + value['output']
        if output.length == 0
          message = 'No events'
          if client != ''
            message = message + ' for ' + msg.match[1]
          msg.send message
        msg.send output.sort().join('\n')

  robot.respond /resolve sensu event (.*)(?:\/)(.*)/i, (msg) ->
    client = addClientDomain(msg.match[1])

    data = {}
    data['client'] = client
    data['check'] = msg.match[2]

    msg.http(process.env.HUBOT_SENSU_API_URL + '/resolve')
      .post(JSON.stringify(data)) (err, res, body) ->
        if res.statusCode == 202
          msg.send 'Event resolved'
        else if res.statusCode == 404
          msg.send msg.match[1] + '/' + msg.match[2] + ' not found'
        else
          msg.send 'API returned an error resolving ' + msg.match[1] + '/' + msg.match[2]


addClientDomain = (client) ->
  domainMatch = new RegExp("\.#{process.env.HUBOT_SENSU_DOMAIN}$", 'i')
  unless domainMatch.test(client)
    client = client + '.' + process.env.HUBOT_SENSU_DOMAIN
  client
