# Description:
#   Github issue link looks for #nnn and links to that issue for your default
#   repo. Eg. "Hey guys check out #273"
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#
# Commands:
#   Listens for #nnn and links to the issue for your default repo on github
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   tenfef

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.hear /.*(#(\d+)).*/, (msg) ->
    issue_number = msg.match[1].replace /#/, ""
    if isNaN(issue_number)
      return

    bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
    issue_title = ""
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    github.get "#{base_url}/repos/#{bot_github_repo}/issues/" + issue_number, (issue_obj) ->
      issue_title = issue_obj.title
      unless process.env.HUBOT_GITHUB_API
        url = "https://github.com"
      else
        url = base_url.replace /\/api\/v3/, ''
      msg.send "Issue #{issue_number}: #{issue_title} #{url}/#{bot_github_repo}/issues/#{issue_number}"
