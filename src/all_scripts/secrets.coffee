# Description:
#   Hubot will tell you its secrets.
#   Example case: Someone in your room wants to add a new service
#   hook in Github. Instead of passing around environment variables,
#   Hubot will know what's up.
#
# Dependencies:
#   (The Campfire adapter is the only supported adapter right now.
#   This may change with time.)
#
# Configuration:
#   HUBOT_CAMPFIRE_ROOM_NAME - Some places, like Github, require the actual room name, *not* the id.
#
# Commands:
#   hubot secrets - Returns room name/id, API key and subdomain

secrets = [
  "My token is #{ process.env.HUBOT_CAMPFIRE_TOKEN }.",
  "I'm currently in room(s) #{ process.env.HUBOT_CAMPFIRE_ROOMS }, with a room name of #{ process.env.HUBOT_CAMPFIRE_ROOM_NAME }.",
  "The subdomain is #{ process.env.HUBOT_CAMPFIRE_ACCOUNT }."
  ]

module.exports = (robot) ->
  robot.respond /secrets/i, (msg) ->
    msg.send secrets.join('\n')
