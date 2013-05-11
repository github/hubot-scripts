# Description:
#   Send messages to all chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ANNOUNCE_ROOMS - comma-separated list of rooms
#
# Commands:
#   hubot announce "<message>" - Sends a message to all hubot rooms.
#   hubot announce downtime for "<service>" starting <timeframe> - Syntactic sugar for announcing downtime commencement
#   hubot announce downtime complete for "<service>" - Syntactic sugar for announcing downtime completion
#
# Author:
#   Morgan Delagrange
#
# URLS:
#   /broadcast/create - Send a message to designated, comma-separated rooms.

module.exports = (robot) ->

  if process.env.HUBOT_ANNOUNCE_ROOMS
    allRooms = process.env.HUBOT_ANNOUNCE_ROOMS.split(',')
  else
    allRooms = []

  robot.respond /announce "(.*)"/i, (msg) ->
    announcement = msg.match[1]
    for room in allRooms
      robot.messageRoom room, announcement

  robot.respond /announce downtime for "(.*)" starting (.*)/i, (msg) ->
    user = msg.message.user
    service = msg.match[1]
    startTime = msg.match[2]

    message = ["The '#{service}' service will be going down for maintenance starting #{startTime}.",
      "If you have questions about this maintenance, please talk to #{user.name} in the the #{user.room} room.  Thank you for your patience."]

    for room in allRooms
      robot.messageRoom room, message...
    msg.reply "Don't forget to pause monitoring for this service."

  robot.respond /announce downtime complete for "(.*)"/i, (msg) ->
    service = msg.match[1]
    for room in allRooms
      robot.messageRoom room, 
          "Maintenance for the '#{service}' service is complete."
    msg.reply "Don't forget to resume monitoring for this service."

  robot.router.post "/broadcast/create", (req, res) ->
    if req.body.rooms
      rooms = req.body.rooms.split(',')
    else
      rooms = allRooms

    for room in rooms
      robot.messageRoom room, req.body.message
    res.end "Message Sent"
