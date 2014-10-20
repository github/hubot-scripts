# Description:
#   "Accepts POST data and broadcasts it"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLs:
#   POST /hubot/say
#     message = <message>
#     room = <room>
#     type = <type>
#
#   curl -X POST http://localhost:8080/hubot/say -d message=lala -d room='#dev'
#
# Author:
#   insom
#   luxflux

module.exports = (robot) ->
  robot.router.post "/hubot/say", (req, res) ->
    body = req.body
    room = body.room
    message = body.message

    robot.logger.info "Message '#{message}' received for room #{room}"

    envelope = robot.brain.userForId 'broadcast'
    envelope.user = {}
    envelope.user.room = envelope.room = room if room
    envelope.user.type = body.type or 'groupchat'

    if message
      robot.send envelope, message

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks\n'
