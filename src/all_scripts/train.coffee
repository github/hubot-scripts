# Description:
#   A way to interact with the NS (Dutch Railways) API
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_NS_API_EMAIL
#   HUBOT_NS_API_PASSWORD
#
# Commands:
#   hubot train disruptions <station> - Retrieve the list of disruptions near <station>. <station> can be a station code (e.g. 'asd') or (part of) a station name (e.g. 'Amsterdam Centraal')
#
# Author:
#   marceldegraaf

xml2js = require 'xml2js'

disruptionApiUrl = 'http://webservices.ns.nl/ns-api-storingen'
disruptionPageRoot = 'http://www.ns.nl/storingen/index.form#'

module.exports = (robot) ->

  robot.respond /train disruptions (.*)/i, (msg) ->
    station = msg.match[1]
    station.replace(/^\s+|\s+$/g, "")

    findDisruptions msg, station, (list) ->

      if list.Ongepland == undefined || list.Gepland == undefined
        msg.send "Sorry, that didn't work. Perhaps the NS API is down or your credentials are wrong?"
        return

      #
      # Unplanned disruptions
      #
      if list.Ongepland[0].Storing == undefined
        msg.send "There are no unplanned disruptions around '#{station}'"
      else
        sendDisruptions list.Ongepland[0].Storing, msg, false

      #
      # Planned disruptions
      #
      if list.Gepland[0].Storing == undefined
        msg.send "There are no planned maintenance disruptions around '#{station}'"
      else
        sendDisruptions list.Gepland[0].Storing, msg, true

findDisruptions = (msg, station, callback) ->
  url = disruptionApiUrl
  username = process.env.HUBOT_NS_API_EMAIL
  password = process.env.HUBOT_NS_API_PASSWORD
  auth = "Basic " + new Buffer(username + ':' + password).toString('base64')

  parser = new xml2js.Parser({explicitArray: true})

  msg.http(url)
    .header('Authorization', auth)
    .query(station: station, actual: false, unplanned: false)
    .get() (err, res, body) ->
      parser.parseString body, (err, result) ->
        callback result

sendDisruptions = (disruptions, msg, planned) ->
  for disruption in disruptions
    if planned
      type = ''
      urlInfix = 'werkzaamheden-'
    else
      type = ':warning:'
      urlInfix = ''

    output = [
      type,
      disruption.Traject[0],
      "(#{disruption.Reden[0]}).",
      "More info: #{disruptionPageRoot}#{urlInfix}#{disruption.id[0]}"
    ]
    msg.send output.join(' ')
