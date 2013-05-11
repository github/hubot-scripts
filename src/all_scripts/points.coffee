# Description:
#   Give, Take and List User Points
#
# Dependencies:
#   None
#
# Configuration:
#   None
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

points = {}

award_points = (msg, username, pts) ->
    points[username] ?= 0
    points[username] += parseInt(pts)
    msg.send pts + ' Awarded To ' + username

save = (robot) ->
    robot.brain.data.points = points

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        points = robot.brain.data.points or {}

    robot.respond /give (\d+) points to (.*?)\s?$/i, (msg) ->
        award_points(msg, msg.match[2], msg.match[1])
        save(robot)

    robot.respond /give (.*?) (\d+) points/i, (msg) ->
        award_points(msg, msg.match[1], msg.match[2])
        save(robot)
    
    robot.respond /take all points from (.*?)\s?$/i, (msg) ->
        username = msg.match[1]
        points[username] = 0
        msg.send username + ' WHAT DID YOU DO?!'
        save(robot)

    robot.respond /take (\d+) points from (.*?)\s?$/i, (msg) ->
         pts = msg.match[1]
         username = msg.match[2]
         points[username] ?= 0
         
         if points[username] is 0
             msg.send username + ' Does Not Have Any Points To Take Away'
         else
             points[username] -= parseInt(pts)
             msg.send pts + ' Points Taken Away From ' + username

         save(robot)

    robot.respond /how many points does (.*?) have\??/i, (msg) ->
        username = msg.match[1]
        points[username] ?= 0

        msg.send username + ' Has ' + points[username] + ' Points'
       
