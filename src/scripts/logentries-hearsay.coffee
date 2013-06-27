# Description:
#  Accepts alert POSTs from logentries at `<hubot server>/hubot/logentries`
#  and broadcasts the alert name in a specified room.
#
#  Example broadcast for an Exit timeout alert:
#
#    "Logentries (Production Alert): Exit timeout"
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
#                "name": "500 error" // Alert name
#            },
#            "host": {
#                "name": "Web", // Host name
#                "hostname": "web.example.com" // Host DNS name
#            },
#            "log": {
#                "name": "access.log" // Log name
#            },
#            "event": <event hash>, // Trigerring event
#            "context": [ // Events in context
#                <event hashes>
#            ]
#        }

# TODO: move rooms into request path: hubot/<room-numbers>/logentries/
#       as to not require the ENV var.

module.exports = (robot) ->
  robot.router.post "/hubot/logentries", (req, res) ->

    if req.body.payload
      data = JSON.parse req.body.payload
      alert = data.alert.name

      robot.logger.info "Alert POSTed from LogEntries: #{alert}"

      user = robot.brain.userForId 'broadcast'
      if process.env.LOGENTRIES_ROOM
        user.room = process.env.LOGENTRIES_ROOM
      user.type = 'groupchat'

      robot.send user, "Logentries (Production Alert): #{alert}"

      res.writeHead 200, {'Content-Type': 'text/plain'}
      res.end 'Thanks\n'
    else
      robot.logger.error "Logentries: unexpected message format"
      robot.logger.info JSON.stringify(req.body)
      res.writeHead 422, {'Content-Type': 'text/plain'}
      res.end 'Expected payload JSON string to exist\n'