#
# See the status of NYC subways
#
# mta me <train> - the status of a nyc subway line
#

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
            if k.status == 'GOOD SERVICE'
              msg.send 'the ' + str + ' train is ok!'
            else if k.status == 'PLANNED WORK'
              msg.send 'heads up, the ' + str + ' train has planned work.'
            else
              msg.send 'the ' + str + ' train is all kinds of messed up'
      else
        msg.send 'thats not a valid subway line!'