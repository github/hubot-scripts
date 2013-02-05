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
#
#   curl -X POST http://localhost:8080/hubot/say -d message=lala -d room='#dev'
#
# Author:
#   insom
#   luxflux

module.exports = (robot) ->
  robot.router.post "/hubot/say", (req, res) ->

    room = req.body.room
    message = req.body.message

    robot.logger.info "Message '#{message}' received for room #{room}"

    user = robot.brain.userForId 'broadcast'
    user.room = room
    user.type = 'groupchat'

    if message
      robot.send user, "#{message}"

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks\n'
