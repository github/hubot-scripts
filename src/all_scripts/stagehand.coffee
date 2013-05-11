# Description:
#   Stagehand manages who is currently using your team's staging server
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   stagehand who - Show who has booked the staging server and how much time they have left
#   stagehand book [minutes] - Book the staging server and optionally specify usage time. Default is 30min
#   stagehand cancel - Cancel the current booking
#
# Author:
#   tinifni

bookStaging = (data, user, minutes) ->
  return false if data.user != user && new Date() < data.expires
  unless data.user == user && new Date() < data.expires
    data.user = user
    data.expires = new Date()
  data.expires = new Date(data.expires.getTime() + minutes * 1000 * 60)

status = (data) ->
  return 'Staging is free for use.' unless new Date() < data.expires
  data.user + ' has staging booked for the next ' \
            + Math.ceil((data.expires - new Date())/(60*1000)) \
            + ' minutes.'

cancelBooking = (data) ->
  data.expires = new Date(0)

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.stagehand ||= { user: "initial", expires: new Date(0) }

  robot.respond /stagehand book( \d+)*/i, (msg) ->
    if msg.match[1] == undefined
      minutes = 30
    else
      minutes = Number(msg.match[1])
    bookStaging(robot.brain.data.stagehand, msg.message.user.name, minutes)
    msg.send status(robot.brain.data.stagehand)

  robot.respond /stagehand who/i, (msg) ->
    msg.send status(robot.brain.data.stagehand)

  robot.respond /stagehand cancel/i, (msg) ->
    cancelBooking(robot.brain.data.stagehand)
    msg.send status(robot.brain.data.stagehand)
