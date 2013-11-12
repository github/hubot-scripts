# Description
#   Perform DNS lookups using node's DNS resolve method
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   hubot dns hostname
#   hubot dns hostname record
#
# Author:
#   mikeycgto

dns = require 'dns'

module.exports = (robot) ->
  robot.respond /dns ([^ ]+)( (.*))?/i, (msg) ->
    host = msg.match[1]
    record = msg.match[3] || 'A'

    dns.resolve host, record, (err, addresses) ->
      if err
        msg.send "DNS Error: #{err}"
      else
        msg.send "DNS Results: #{addresses.join ' '}"
