# Description:
#   Fetches METAR and TAF information from the National Weather Service
#
# Dependencies:
#   "xml2js":"0.4.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot taf [for] <station identifier> - returns the most recent TAF within the last day for the given station
#   hubot metar [for] <station identifier> - returns the most recent METAR within the last day for the given station
#   hubot awx [for] <station identifier> - alias for running both TAF and METAR commands for the given station
#
# Author:
#   wubr

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /metar (for )?(\w+)$/i, (msg) ->
    stationString = msg.match[2]
    getMetar(msg, stationString)

  robot.respond /taf (for )?(\w+)$/i, (msg) ->
    stationString = msg.match[2]
    getTaf(msg, stationString)

  robot.respond /awx (for )?(\w+)$/i, (msg) ->
    stationString = msg.match[2]
    getMetar(msg, stationString)
    getTaf(msg, stationString)

getMetar = (msg,stationString) ->
  url = 'http://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&mostRecentForEachStation=constraint&hoursBeforeNow=24&&stationString=' + stationString
  msg.http(url).get() (err, res, body) ->
    if err
      msg.send "Error: #{err}"
      return
    parser = new xml2js.Parser({explicitArray: true})
    parser.parseString body, (err, result) ->
      if err
        msg.send "Error: #{err}"
        return
      msg.send 'METAR ' + result["response"]["data"][0]["METAR"][0]["raw_text"][0]  

getTaf = (msg,stationString) ->
  url = 'http://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=tafs&requestType=retrieve&format=xml&hoursBeforeNow=24&timeType=issue&mostRecent=true&stationString=' + stationString
  msg.http(url).get() (err, res, body) ->
    if err
      msg.send "Error: #{err}"
      return
    parser = new xml2js.Parser({explicitArray: true})
    parser.parseString body, (err, result) ->
      if err
        msg.send "Error: #{err}"
        return
      msg.send 'TAF ' + result["response"]["data"][0]["TAF"][0]["raw_text"][0]  
