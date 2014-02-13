# Description:
#   See the status of NYC subways
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot mta me <train> - the status of a nyc subway line
#
# Author:
#   jgv

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /mta\s*(?:me)?\s*(\w+)?/i, (msg) ->
    mtaMe msg

mtaMe = (msg) ->
  msg.http('http://mta.info/status/serviceStatus.txt')
  .get() (err, res, body) ->
    if err
      throw err
    parser = new xml2js.Parser({'explicitRoot' : 'service', 'normalize' : 'false' })
    parser.parseString body, (err, res) ->
      if err
        throw err
      re = new RegExp(msg.match[1], 'gi')
      if msg.match[1].length is 1 or msg.match[1].toUpperCase() is 'SIR'
        for k in res.service.subway.line
          str = k.name
          if str.match(re)
            switch k.status
              when "GOOD SERVICE"
                msg.send "the #{str} train is ok!"
              when "PLANNED WORK"
                msg.send "heads up, the #{str} train has planned work (updated #{k.Time})"
              when "SERVICE CHANGE"
                msg.send "the #{str} train has service changes (updated #{k.Time})"
              when "DELAYS"
                msg.send "the #{str} train is delayed (updated #{k.Time})"
              else
                msg.send "the #{str} train status is #{k.status}"
      else
        msg.send "that's not a valid subway line!"
