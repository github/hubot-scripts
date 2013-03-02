# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>
#

https = require 'https'

module.exports = (robot) ->
    ###
    req = https.request {
        host: 'api.github.com'
        method: 'POST'
        path: '/authorizations'
        headers: {
            'Accept': 'application/json'
            'Content-Length': payload.length
        }
    }, (res) ->
        console.log "Status #{res.statusCode}"
        res.on 'data', (data) ->
            console.log data.toString()

    req.end payload
    ###

    robot.respond /ping/i, (res) ->
        res.send 'pong'

    robot.router.get '/pull', (req, res) ->
        req.on 'data', (data) ->
            console.log data.toString()
