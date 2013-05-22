# Description:
#   Overloads pagerduty plugin commands to record and display
#   override points for different users.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pager me <number> - award <number> points to the user
#   hubot pager me points - should current points
#
# Notes:
#
# Author:
#   nstielau
#
#
# Thanks for brettlangdon and monde for their points plugin:
# https://github.com/github/hubot-scripts/blob/master/src/scripts/points.coffee

pager_points = {}

award_points = (msg, username, pts) ->
    pager_points[username] ?= 0
    pager_points[username] += parseInt(pts)

save = (robot) ->
    robot.brain.data.pager_points = pager_points

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        points = robot.brain.data.pager_points or {}

    # Catch override requests, and award points
    robot.respond /pager( me)? (\d+)/i, (msg) ->
        email = msg.message.user.pagerdutyEmail
        minutes = parseInt msg.match[2]
        award_points(msg, email, minutes)
        save(robot)

    # Show current point scoreboard
    robot.respond /pager( me)? points/i, (msg) ->
        for username, user_points of pager_points
            if username and user_points:
                msg.send username + ' has ' + user_points + ' override minutes clocked'

    # DEBUG: helper for testing without the pagerduty plugin
    robot.respond /pager(?: me)? as (.*) for points/i, (msg) ->
      email = msg.match[1]
      unless msg.message.user.pagerdutyEmail
        msg.message.user.pagerdutyEmail = email

    # DEBUG: Clear points
    robot.respond /pager( me)? clear points/i, (msg) ->
        pager_points = {}
        save(robot)