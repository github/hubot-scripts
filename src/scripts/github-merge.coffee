# Description:
#   Integrate with GitHub merge API
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_USER
#
# Commands:
#   hubot merge project_name/<head> into <base> - merges the selected branches or SHA commits
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   maletor

module.exports = (robot) ->
  github = require("githubot")(robot)

  # http://rubular.com/r/vnnwHvt75L
  robot.respond /merge ([-_\.0-9a-zA-Z]+)(\/([-_\.a-zA-z0-9\/]+))? into ([-_\.a-zA-z0-9\/]+)$/i, (msg) ->
    app      = github.qualified_repo msg.match[1]
    head     = msg.match[3] || "master"
    base     = msg.match[4]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url      = "#{base_url}/repos/#{app}/merges"

    github.post url, { base: base, head: head }, (merge) ->
      if merge.message
        msg.send merge.message
      else
        msg.send "Merged the crap out of it"
