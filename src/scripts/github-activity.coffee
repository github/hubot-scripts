# Description:
#   None
#
# Dependencies:
#   "date-utils": ">=1.2.5"
#   "githubot": "0.2.0"
# 
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#
# Commands:
#   hubot repo show <repo> - shows activity of repository
#
# Author:
#   vquaiato

require('date-utils')

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /repo show (.*)$/i, (msg) ->
    repo = github.qualified_repo msg.match[1]
    url = "https://api.github.com/repos/#{repo}/commits"

    github.get url, (commits) ->
      if commits.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
      else if commits.length == 0
          msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
      else
        msg.send "http://github.com/#{repo}"
        send = 5
        for c in commits
          if send
            d = new Date(Date.parse(c.commit.committer.date)).toFormat("DD/MM HH24:MI")
            msg.send "[#{d} -> #{c.commit.committer.name}] #{c.commit.message}"
            send -= 1
