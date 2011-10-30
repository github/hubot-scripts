# Show open issues from a Github repository.
#
# You need to set the following variables:
#   HUBOT_GITHUB_TOKEN ="<oauth token>"
#   HUBOT_GITHUB_USER ="<user name>"
#
# HUBOT_GITHUB_USER is optional, but if you set it, you can ask `show me issues
# for hubot` instead of `show me issues for github/hubot`.
#
# show me issues for <user/repo> -- Shows open issues for that project.
module.exports = (robot) ->
  robot.respond /show\s+(me\s+)?issues\s+(for\s+)?(.*)/i, (msg)->
    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    repo = msg.match[3].toLowerCase()
    repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless ~repo.indexOf("/")
    msg.http("https://api.github.com/repos/#{repo}/issues")
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
      .query(state: "open", sort: "created")
      .get() (err, res, body) ->
        if err
          msg.send "GitHub says: #{err}"
          return
        issues = JSON.parse(body)
        if issues.length == 0
            msg.send "Achievement unlocked: issues zero!"
        else
          for issue in issues
            labels = ("##{label.name}" for label in issue.labels).join(" ")
            assignee = if issue.assignee then " (#{issue.assignee.login})" else ""
            msg.send "[#{issue.number}] #{issue.title} #{labels}#{assignee} = #{issue.html_url}"

