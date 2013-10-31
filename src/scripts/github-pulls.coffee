# Description:
#   Show open pull requests from a Github repository or organization
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_ORG
#
# Commands:
#   hubot show [me] <user/repo> pulls [with <regular expression>] -- Shows open pull requests for that project by filtering pull request's title.
#   hubot show [me] <repo> pulls -- Show open pulls for HUBOT_GITHUB_USER/<repo>, if HUBOT_GITHUB_USER is configured
#   hubot show [me] org-pulls [for <organization>] -- Show open pulls for all repositories of an organization, default is HUBOT_GITHUB_ORG
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

  unless (url_api_base = process.env.HUBOT_GITHUB_API)?
    url_api_base = "https://api.github.com"

  robot.respond /show\s+(me\s+)?(.*)\s+pulls(\s+with\s+)?(.*)?/i, (msg)->
    repo = github.qualified_repo msg.match[2]
    filter_reg_exp = new RegExp(msg.match[4], "i") if msg.match[3]

    github.get "#{url_api_base}/repos/#{repo}/pulls", (pulls) ->
      if pulls.length == 0
        summary = "Achievement unlocked: open pull requests zero!"
      else
        filtered_result = []
        for pull in pulls
          if filter_reg_exp && pull.title.search(filter_reg_exp) < 0
            continue
          filtered_result.push(pull)

        if filtered_result.length == 0
          summary = "There's no open pull request for #{repo} matching your filter!"
        else if filtered_result.length == 1
          summary = "There's only one open pull request for #{repo}:"
        else
          summary = "I found #{filtered_result.length} open pull requests for #{repo}:"

        for pull in filtered_result
          summary = summary + "\n\t#{pull.title} - #{pull.user.login}: #{pull.html_url}"

      msg.send summary

  robot.respond /show\s+(me\s+)?org\-pulls(\s+for\s+)?(.*)?/i, (msg) ->

    org_name = msg.match[3] || process.env.HUBOT_GITHUB_ORG

    unless (org_name)
      msg.send "No organization specified, please provide one or set HUBOT_GITHUB_ORG accordingly."
      return

    url = "#{url_api_base}/orgs/#{org_name}/issues?filter=all"
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
          summary = "There's only one open pull request for #{org_name}:"
        else
          summary = "I found #{filtered_result.length} open pull requests for #{org_name}:"

        for issue in filtered_result
          summary = summary + "\n\t#{issue.repository.name}: #{issue.title} (#{issue.user.login}) -> #{issue.pull_request.html_url}"

      msg.send summary
