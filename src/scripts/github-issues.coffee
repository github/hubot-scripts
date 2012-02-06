# Show open issues from a Github repository.
#
# You need to set the following variable:
#   HUBOT_GITHUB_TOKEN = "<oauth token>"
#
# You may optionally set the following variables:
#   HUBOT_GITHUB_USER = "<default user/org name>"
#   HUBOT_GITHUB_REPO = "<default repo>"
#   HUBOT_GITHUB_USER_(.*) = "<GitHub username for matching chat handle>"
#
# If HUBOT_GITHUB_USER is set, you can ask `show me issues for hubot` instead
# of `show me issues for github/hubot`.
#
# If HUBOT_GITHUB_REPO is set, you can ask `show me issues` instead of `show
# me issues for github/hubot`.
#
# If, for example, HUBOT_GITHUB_USER_JOHN is set to GitHub user login
# 'johndoe1', you can ask `show john's issues` instead of `show johndoe1's
# issues`. This is useful for mapping chat handles to GitHub logins.
#
# show [me] [<limit> [of]] [<assignee>'s|my] [<label>] issues [for <user/repo>] [about <query>] -- Shows open GitHub issues for repo.

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

# Resolve repo to a qualified GitHub repo using environment variables.
complete_repo = (repo) ->
  repo = process.env.HUBOT_GITHUB_REPO unless repo?
  repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless _s.include repo, "/"
  repo

module.exports = (robot) ->
  robot.respond ASK_REGEX, (msg) ->
    criteria = parse_criteria msg.message.text
    criteria.repo = complete_repo criteria.repo
    criteria.assignee = complete_assignee msg, criteria.assignee if criteria.assignee?

    query_params = state: "open", sort: "created"
    query_params.labels = criteria.label if criteria.label?
    query_params.assignee = criteria.assignee if criteria.assignee?

    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    msg.http("https://api.github.com/repos/#{criteria.repo}/issues")
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
      .query(query_params)
      .get() (err, res, body) ->
        if err
          msg.send "GitHub says: #{err}"
          return

        issues = JSON.parse(body)
        issues = filter_issues issues, criteria
       
        if _.isEmpty issues
            msg.send "No issues found."
        else
          for issue in issues
            labels = ("##{label.name}" for label in issue.labels).join(" ")
            assignee = if issue.assignee then " (#{issue.assignee.login})" else ""
            msg.send "[#{issue.number}] #{issue.title} #{labels}#{assignee} = #{issue.html_url}"

# require('../../test/scripts/github-issues_test').test parse_criteria
