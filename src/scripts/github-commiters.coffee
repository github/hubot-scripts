# Description:
#   Show the commiters from a repo
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#
# Commands:
#   hubot repo commiters <repo> - shows commiters of repository
#   hubot repo top-commiters <repo> - shows top commiters of repository
#
# Author:
#   vquaiato

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /repo commiters (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          max_length = commits.length
          max_length = 20 if commits.length > 20
          for commit in commits
            msg.send "[#{commit.login}] #{commit.contributions}"
            max_length -= 1
            return unless max_length

  robot.respond /repo top-commiter (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          top_commiter = null
          for commit in commits
            top_commiter = commit if top_commiter == null
            top_commiter = commit if commit.contributions > top_commiter.contributions 
          msg.send "[#{top_commiter.login}] #{top_commiter.contributions} :trophy:"

  read_contributors = (msg, response_handler) ->
      repo = github.qualified_repo msg.match[1]
      url = "https://api.github.com/repos/#{repo}/contributors"
      github.get url, (commits) ->
        if commits.message
          msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
        else if commits.length == 0
          msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
        else
          msg.send "http://github.com/#{repo}"
          response_handler commits
