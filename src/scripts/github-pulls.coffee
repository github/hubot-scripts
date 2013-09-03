# Description:
#   Show open pull requests from a Github repository or organization
#
# Dependencies:
#   "githubot": "0.2.0"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_ORG
#
# Commands:
#   hubot show [me] <user/repo> pulls [with <regular expression>] -- Shows open pull requests for that project by filtering pull request's title.
#   hubot show [me] hubot pulls -- Show open pulls for a given user IFF HUBOT_GITHUB_USER is configured
#   hubot show [me] org pulls -- Show open pulls for an organization, if HUBOT_GITHUB_ORG is configured
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
#   You can further filter pull request title by providing a reguar expression.
#   For example, `show me hubot pulls with awesome fix`.
#
# Author:
#   jingweno

module.exports = (robot) ->

  github = require("githubot")(robot)

  robot.respond /show\s+(me\s+)?(.*)\s+pulls(\s+with\s+)?(.*)?/i, (msg)->
    repo = github.qualified_repo msg.match[2]
    filter_reg_exp = new RegExp(msg.match[4], "i") if msg.match[3]
    unless (url_api_base = process.env.HUBOT_GITHUB_API)?
      url_api_base = "https://api.github.com"

    github.get "#{url_api_base}/repos/#{repo}/pulls", (pulls) ->
      if pulls.length == 0
        msg.send "Achievement unlocked: open pull requests zero!"
      else
        filtered_result = []
        for pull in pulls
          if filter_reg_exp && pull.title.search(filter_reg_exp) < 0
            continue
          filtered_result.push(pull)

        if filtered_result.length == 0
          summary = "no open pull request is found"
        else if filtered_result.length == 1
          summary = "1 open pull request is found:"
        else
          summary = "#{filtered_result.length} open pull requests are found:"

        msg.send summary

        for pull in filtered_result
          msg.send "\t#{pull.title} - #{pull.user.login}: #{pull.html_url}"

  robot.respond /show\s+(me\s+)?org pulls/i, (msg) ->
    unless (process.env.HUBOT_GITHUB_ORG)
      msg.send "No organization specified, please set HUBOT_GITHUB_ORG accordingly."
      return

    msg.send "I'll check for any open pull request within #{process.env.HUBOT_GITHUB_ORG}, just a sec..."

    unless (url_api_base = process.env.HUBOT_GITHUB_API)?
      url_api_base = "https://api.github.com"

    url = "#{url_api_base}/orgs/#{process.env.HUBOT_GITHUB_ORG}/issues?filter=all"
    github.get url, (issues) ->
      if issues.length == 0
        summary = "Achievement unlocked: open pull requests zero!"
      else
        filtered_result = []
        for issue in issues
          if issue.pull_request.html_url == null
            continue
          filtered_result.push(issue)

        if filtered_result.length == 0
          summary = "Achievement unlocked: open pull requests zero!"
        else if filtered_result.length == 1
          summary = "There's only one open pull request:"
        else
          summary = "I got #{filtered_result.length} open pull requests for you:"

        msg.send summary

        for issue in filtered_result
          msg.send " #{issue.repository.name}: #{issue.title} (#{issue.user.login}) -> #{issue.pull_request.html_url}"
