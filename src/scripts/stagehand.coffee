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
#   stagehand who [env] - Show who has booked the staging server and how much time they have left
#   stagehand book [env] [minutes] - Book the staging server and optionally specify usage time. Default is 30min
#   stagehand cancel [env] - Cancel the current booking
#
# Author:
#   tinifni

class Message
  constructor: (env, minutes) ->
    @env = env
    @minutes = minutes
  getEnv: ->
    if @env == undefined
      return 'staging'
    else
      return @env

  getMinutes: ->
    if @minutes == undefined
      return 30
    else
      return Number(@minutes)

bookEnv = (data, user, minutes) ->
  return false if data.user != user && new Date() < data.expires
  unless data.user == user && new Date() < data.expires
    data.user = user
    data.expires = new Date()
  data.expires = new Date(data.expires.getTime() + minutes * 1000 * 60)

status = (env, data) ->
  return env + ' is free for use.' unless new Date() < data.expires
  data.user + ' has ' + env + ' booked for the next ' \
            + Math.ceil((data.expires - new Date())/(60*1000)) \
            + ' minutes.'

cancelBooking = (data) ->
  data.expires = new Date(0)

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.stagehand ||= {}
    for env in ['staging', 'development', 'production']
      do (env) ->
        robot.brain.data.stagehand[env] ||= { user: "initial", expires: new Date(0) }

  robot.respond /stagehand book\s?([A-Za-z]+)*\s?(\d+)*/i, (msg) ->
    message = new Message(msg.match[1], msg.match[2])
    env = message.getEnv()
    minutes = message.getMinutes()

    bookEnv(robot.brain.data.stagehand[env], msg.message.user.name, minutes)
    msg.send status(env, robot.brain.data.stagehand[env])

  robot.respond /stagehand who\s?([A-Za-z]+)*/i, (msg) ->
    message = new Message(msg.match[1])
    env = message.getEnv()

    msg.send status(env, robot.brain.data.stagehand[env])

  robot.respond /stagehand cancel\s?([A-Za-z]+)*/i, (msg) ->
    message = new Message(msg.match[1])
    env = message.getEnv()

    cancelBooking(robot.brain.data.stagehand[env])
    msg.send status(env, robot.brain.data.stagehand[env])
