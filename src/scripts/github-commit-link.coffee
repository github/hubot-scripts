# Description:
#   Github commit link looks for <SHA> and links to that commit for your default
#   repo. Eg. "Hey guys check out commit 251a8fb"
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_REPO
#     The `user/repository` that you want to connect to. example: github/hubot-scripts
#   HUBOT_GITHUB_USER
#     The `user` that you want to connect to. example: github
#   HUBOT_GITHUB_TOKEN
#     You can retrieve your github token via:
#       curl -i https://api.github.com/authorizations -d '{"scopes":["repo"]}' -u "yourusername"
#     Enter your Github password when prompted. When you get a response, look for the "token" value
#
#     See the following for more details:
#       http://developer.github.com/v3/oauth/#create-a-new-authorization
#       https://github.com/iangreenleaf/githubot
#   HUBOT_GITHUB_API
#     Optional, default is https://api.github.com. Override with
#     http[s]://yourdomain.com/api/v3/ for Enterprise installations.
#
# Commands:
#   Listens for <SHA>s with at least seven characters:
#     <SHA>            links to that commit in HUBOT_GITHUB_REPO
#     repo@<SHA>       links to that commit in HUBOT_GITHUB_USER's repo
#     user/repo@<SHA>  links to that commit in user/repo
#   Unless the string 'commit/' shows up in the line, in which case it
#   is ignored.
#
# Author:
#   achiu

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.hear ///
      ^.*?              # non-greedy pre-commit-reference text
      \b                # word boundary before the commit reference
      (?:([^\s@]+)@)?   # optional repo@ or user/repo@ qualifier
      ([0-9a-f]{7,40})  # commit hash (>= 7 and <= 40 hex digits long)
      \b                # word boundary after the commit reference
      .*$               # post-commit-reference text
      ///i, (msg) ->
    if process.env.HUBOT_GITHUB_REPO && process.env.HUBOT_GITHUB_TOKEN
      if !(msg.message.text.match(/commit\//))
        commit_sha = msg.match[2]
        if msg.match[1]?
          bot_github_repo = github.qualified_repo msg.match[1]
        else
          bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
        issue_title = ""
        base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
        github.get "#{base_url}/repos/#{bot_github_repo}/commits/" + commit_sha, (commit_obj) ->
          if process.env.HUBOT_GITHUB_API
            url = commit_obj.url.replace(/api\/v3\//,'')
          else
            url = commit_obj.url.replace(/api\./,'')
          url = url.replace(/repos\//,'')
          url = url.replace(/commits/,'commit')
          msg.send "Commit: " + commit_obj.commit.message.split("\n")[0] + "\n" + url
    else
      msg.send "Hey! You need to set HUBOT_GITHUB_REPO and HUBOT_GITHUB_TOKEN before I can link to that commit."
