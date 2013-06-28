# Description:
#  Accepts alert POSTs from logentries at `<hubot server>/hubot/logentries`
#  and broadcasts the alert name in a specified room.
#
#  Example broadcast for an Exit timeout alert:
#
#    "[<Your Logentries App Name> Logs]: Exit timeout"
#
# Dependencies:
#   None
#
# Configuration:
#   LOGENTRIES_ROOM
#     room number where hubot will say what alerts
#     were received from logentries
#
# Commands:
#   None
#
# URLs:
#   POST /hubot/logentries
#
# Author:
#   eprothro
#

# https://logentries.com/doc/webhookalert/
# The body.payload contains the following JSON string:
#
#        {
#            "alert": {
#                "name": "Logentries Alert Name"
#            },
#            "host": {
#                "name": "Host name",
#                "hostname": "web.example.com"
#            },
#            "log": {"name": "Logentries application name"},
#            "event": <triggering event information object>,
#            "context": [<context event information objects>]
#        }

# TODO: move rooms into request path: hubot/<room-numbers>/logentries/
#       as to not require the ENV var.
#
# TODO: add link to go to logentries log from broadcast

module.exports = (robot) ->
  robot.router.post "/hubot/logentries", (req, res) ->

    if req.body.payload
      data = JSON.parse req.body.payload
      alert = data.alert.name
      name = data.log.name

      robot.logger.info "Alert POSTed from LogEntries: #{alert}"

      user = robot.brain.userForId 'broadcast'
      if process.env.LOGENTRIES_ROOM
        user.room = process.env.LOGENTRIES_ROOM
      user.type = 'groupchat'

      robot.send user, "[#{name} Logs]: #{alert}"

      res.writeHead 200, {'Content-Type': 'text/plain'}
      res.end 'Thanks\n'
    else
      robot.logger.error "Logentries: unexpected message format"
      robot.logger.info JSON.stringify(req.body)
      res.writeHead 422, {'Content-Type': 'text/plain'}
      res.end 'Expected payload JSON string to exist\n'