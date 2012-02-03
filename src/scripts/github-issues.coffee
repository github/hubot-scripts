# Show open issues from a Github repository.
#
# You need to set the following variables:
#   HUBOT_GITHUB_TOKEN ="<oauth token>"
#   HUBOT_GITHUB_USER ="<user name>"
#
# HUBOT_GITHUB_USER is optional, but if you set it, you can ask `show me issues
# for hubot` instead of `show me issues for github/hubot`.
#
# HUBOT_GITHUB_REPO is optional, but if you set it, you can ask `show me issues`
# instead of `show me issues for github/hubot`.
#
# show me issues for <user/repo> -- Shows open issues for that project.

_  = require("underscore")
_s = require("underscore.string")

get_username = (name) ->
  name = name.replace("@", "").replace("'s", "")
  resolve = (n) -> process.env["HUBOT_GITHUB_USER_#{n.replace(/\s/g, '_').toUpperCase()}"]
  # Try resolving the name to a GitHub username using full, then first name:
  resolved = resolve(name) or resolve(_s.words(name)[0])
  if resolved? then resolved else name

get_repo = (repo) ->
  repo = process.env.HUBOT_GITHUB_REPO unless repo?
  repo = repo.replace "for ", ""
  "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless ~repo.indexOf("/")

module.exports = (robot) ->
  robot.respond /show (me)?\s*(\d+|\d+ of)?\s*(@?\w+'s|my)?\s*(\S+)?\s*issues\s*(for \S+)?\s*(about .+)?/i, (msg) ->
    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    [limit, assignee, issue_label, repo, query] = msg.match[2..]

    repo = get_repo repo

    msg.http("https://api.github.com/repos/#{repo}/issues")
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
      .query(state: "open", sort: "created")
      .get() (err, res, body) ->
        if err
          msg.send "GitHub says: #{err}"
          return

        issues = JSON.parse(body)

        if assignee?
          assignee = msg.message.user.name if assignee is "my"
          assignee = get_username assignee
          issues = _.filter issues, (i) -> i.assignee? and i.assignee.login is assignee

        if issue_label?
          issues = _.filter issues, (i) -> _.any(i.labels, (l) -> l.name is issue_label)

        if query?
          query = query.replace "about ", ""
          issues = _.filter issues, (i) ->
                    _.any [i.body, i.title], (text) -> _s.include text.toLowerCase(), query

        if limit?
        	limit = parseInt limit.replace " of", ""
        	issues = _.first issues, limit

        if issues.length == 0
            msg.send "No issues found."
        else
          for issue in issues
            labels = ("##{label.name}" for label in issue.labels).join(" ")
            assignee = if issue.assignee then " (#{issue.assignee.login})" else ""
            msg.send "[#{issue.number}] #{issue.title} #{labels}#{assignee} = #{issue.html_url}"
