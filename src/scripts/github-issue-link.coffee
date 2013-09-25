# Description:
#   Github issue link looks for #nnn and links to that issue for your default
#   repo. Eg. "Hey guys check out #273"
#   Defaults to issues in HUBOT_GITHUB_REPO, unless a repo is specified Eg. "Hey guys, check out awesome-repo#273"
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_ISSUE_LINK_IGNORE_USERS
#
# Commands:
#   #nnn - link to GitHub issue nnn for HUBOT_GITHUB_REPO project
#   repo#nnn - link to GitHub issue nnn for repo project
#   user/repo#nnn - link to GitHub issue nnn for user/repo project
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   tenfef

module.exports = (robot) ->
  github = require("githubot")(robot)

  githubIgnoreUsers = process.env.HUBOT_GITHUB_ISSUE_LINK_IGNORE_USERS
  if githubIgnoreUsers == undefined
    githubIgnoreUsers = "github|hubot"

  robot.hear /((\S*|^)?#(\d+)).*/, (msg) ->
    return if msg.message.user.name.match(new RegExp(githubIgnoreUsers, "gi"))
    
    issue_number = msg.match[3]
    if isNaN(issue_number)
      return
    
    if msg.match[2] == undefined
      bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
    else
      bot_github_repo = github.qualified_repo msg.match[2]
    
    issue_title = ""
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    
    github.get "#{base_url}/repos/#{bot_github_repo}/issues/" + issue_number, (issue_obj) ->
      issue_title = issue_obj.title
      unless process.env.HUBOT_GITHUB_API
         url = "https://github.com"
       else
         url = base_url.replace /\/api\/v3/, ''
       msg.send "Issue #{issue_number}: #{issue_title} #{url}/#{bot_github_repo}/issues/#{issue_number}"
