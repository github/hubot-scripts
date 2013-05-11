# Description:
#   None
#
# Dependencies:
#   "date-utils": ">=1.2.5"
#   "hubucket": "git+ssh://git@github.com:pyro2927/hubucket.git"
# 
# Configuration:
#   HUBOT_BITBUCKET_USER
#   HUBOT_BITBUCKET_PASSWORD
#
# Commands:
#   hubot repo show <repo> - shows activity of repository
#
# Author:
#   pyro2927

require('date-utils')

module.exports = (robot) ->
  bitbucket = require("hubucket")(robot)
  robot.respond /repo show (.*)$/i, (msg) ->
    repo = bitbucket.qualified_repo msg.match[1]
    url = "repositories/#{repo}/events/"

    bitbucket.get url, (data) ->
      if data.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{data.message}!"
      else if data.events.length == 0
          msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
      else
        msg.send "https://bitbucket.com/#{repo}"
        send = 5
        for c in data.events
          if send and c.description != null
            for commit in c.description.commits
               d = new Date(Date.parse(c.created_on)).toFormat("MM/DD/YY HH24:MI")
               stamp = "#{d}"
               # events aren't always related to a user, do only conditionally add in the username
               stamp = stamp + " -> #{c.user.username}" if c.user
               # msg.send "#{JSON.stringify(c)}"
               msg.send "[#{stamp}] #{commit.description}"
               send -= 1

