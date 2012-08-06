# Description:
#   Give, Take and List User Points
#
# Dependencies:
#   "redis": "0.7.2"
#
# Configuration:
#   HUBOT_REDIS_HOST
#   HUBOT_REDIS_PORT
#
# Commands:
#   hubot give <number> points to <username> - award <number> points to <username>
#   hubot give <username> <number> points - award <number> points to <username>
#   hubot take <number> points from <username> - take away <number> points from <username>
#   hubot how many points does <username> have? - list how many points <username> has
#   hubot take all points from <username> - removes all points from <username>
#
# Author:
#   brettlangdon
#
redis = require 'redis' 

client = null
host = if process.env.HUBOT_REDIS_HOST then process.env.HUBOT_REDIS_HOST else 'localhost'
port = if process.env.HUBOT_REDIS_PORT then parseInt(process.env.HUBOT_REDIS_PORT) else 6379


award_points = (msg, username, pts) ->
    client.get('hubot.points.'+username, (err,value)->
        if err
            msg.logger.err err
            value = 0

        value = parseInt(value) + parseInt(pts)
        client.set('hubot.points.'+username, value)
        msg.send pts + ' Awarded To ' + username
    )



module.exports = (robot) ->
    robot.respond /give (\d+) points to (.*?)\s?$/i, (msg) ->
        award_points(msg, msg.match[2], msg.match[1])
    robot.respond /give (.*?) (\d+) points/i, (msg) ->
        award_points(msg, msg.match[1], msg.match[2])
    
    robot.respond /take all points from (.*?)\s?$/i, (msg) ->
        username = msg.match[1]
        client.set('hubot.points.'+username, 0)
        msg.send username + ' WHAT DID YOU DO?!'


    robot.respond /take (\d+) points from (.*?)\s?$/i, (msg) ->
         pts = msg.match[1]
         username = msg.match[2]
         client.get('hubot.points.'+username, (err,value)->
             if err
                 msg.logger.err err
                 value = 0
             value = parseInt(value) - parseInt(pts)
             if value < 0
                 value = 0
             client.set('hubot.points.'+username, value)
             msg.send pts + ' Taken Away From ' + username
         )

    robot.respond /how many points does (.*?) have\??/i, (msg) ->
        username = msg.match[1]
        
        client.get('hubot.points.'+username, (err,value) ->
            if err
                msg.logger.err err
                value = 0
            msg.send username + ' Has ' + value + ' Points'
        )
        
    client = redis.createClient(port,host)
    client.on 'error', (err) ->
        robot.logger.error err
    client.on 'connect', ->
        robot.logger.debug 'Connected to Redis'