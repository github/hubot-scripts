# Description:
#   Show open issues from a Github repository
#
# Dependencies:
#   "underscore": "1.3.3"
#   "underscore.string": "2.1.1"
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_REPO
#   HUBOT_GITHUB_USER_(.*)
#   HUBOT_GITHUB_API
#
# Commands:
#   hubot show [me] [<limit> [of]] [<assignee>'s|my] [<label>] issues [for <user/repo>] [about <query>] -- Shows open GitHub issues for repo.
#   hubot show [me] issues for <repo> -- List all issues for given repo IFF HUBOT_GITHUB_USER configured
#   hubot show [me] issues for <user/repo> -- List all issues for given repo
#   hubot show [me] issues -- Lists all issues IFF HUBOT_GITHUB_REPO configured
#   hubot show <chat user's> issues -- Lists all issues for chat user IFF HUBOT_GITHUB_USER_(.*) configured
#
# Notes:
#   If, for example, HUBOT_GITHUB_USER_JOHN is set to GitHub user login
#   'johndoe1', you can ask `show john's issues` instead of `show johndoe1's
#   issues`. This is useful for mapping chat handles to GitHub logins.
#
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   davidsiegel

_  = require("underscore")
_s = require("underscore.string")

ASK_REGEX = ///
  show\s            # Start's with 'show'
  (me)?\s*          # Optional 'me'
  (\d+|\d+\sof)?\s* # 'N of' -- 'of' is optional but ambiguous unless assignee is named
  (\S+'s|my)?\s*    # Assignee's name or 'my'
  (\S+)?\s*         # Optional label name
  issues\s*         # 'issues'
  (for\s\S+)?\s*    # Optional 'for <repo>'
  (about\s.+)?      # Optional 'about <query>'
///i

# Given the text sent to robot.respond (e.g. 'hubot show me...'), parse the
# criteria used for filtering issues.
parse_criteria = (message) ->
  [me, limit, assignee, label, repo, query] = message.match(ASK_REGEX)[1..]
  me: me,
  limit: parseInt limit.replace(" of", "") if limit?,
  assignee: assignee.replace("'s", "") if assignee?,
  label: label,
  repo: repo.replace("for ", "") if repo?,
  query: query.replace("about ", "") if query?

# Filter the issue list by criteria; most of the filtering is handled as part
# of the Issues API, but limit and query paramaters are not part of the API.
filter_issues = (issues, {limit, query}) ->
  if query?
    issues = _.filter issues, (i) -> _.any [i.body, i.title], (s) -> _s.include s.toLowerCase(), query.toLowerCase()
  if limit?
    issues = _.first issues, limit
  issues

# Resolve assignee name to a potential GitHub username using sender
# information and/or environment variables.
complete_assignee = (msg, name) ->
  name = msg.message.user.name if name is "my"
  name = name.replace("@", "")
  # Try resolving the name to a GitHub username using full, then first name:
  resolve = (n) -> process.env["HUBOT_GITHUB_USER_#{n.replace(/\s/g, '_').toUpperCase()}"]
  resolve(name) or resolve(name.split(' ')[0]) or name

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond ASK_REGEX, (msg) ->
    criteria = parse_criteria msg.message.text
    criteria.repo = github.qualified_repo criteria.repo
    criteria.assignee = complete_assignee msg, criteria.assignee if criteria.assignee?

    query_params = state: "open", sort: "created"
    query_params.labels = criteria.label if criteria.label?
    query_params.assignee = criteria.assignee if criteria.assignee?

    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    github.get "#{base_url}/repos/#{criteria.repo}/issues", query_params, (issues) ->
      issues = filter_issues issues, criteria

      if _.isEmpty issues
          msg.send "No issues found."
      else
        for issue in issues
          labels = ("##{label.name}" for label in issue.labels).join(" ")
          assignee = if issue.assignee then " (#{issue.assignee.login})" else ""
          msg.send "[#{issue.number}] #{issue.title} #{labels}#{assignee} = #{issue.html_url}"

# require('../../test/scripts/github-issues_test').test parse_criteria
