# Github issue link looks for #nnn and links to that issue for your default repo. Eg. "Hey guys check out #273"
# Requires vars HUBOT_GITHUB_REPO, and HUBOT_GITHUB_TOKEN to be set.
#
# Listens for #nnn and links to the issue for your default repo on github

module.exports = (robot) ->
  robot.hear /.*(#(\d+)).*/, (msg) ->
    issue_number = msg.match[1].replace /#/, ""
    if isNaN(issue_number)
      return

    bot_github_repo = process.env.HUBOT_GITHUB_REPO
    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    issue_title = ""
    msg.http("https://api.github.com/repos/#{bot_github_repo}/issues/" + issue_number)
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
      .get() (err, res, body) ->

        if err
          return

        issue_obj = JSON.parse(body)
        issue_title = issue_obj.title
        msg.send "Issue " + issue_number + ": " + issue_title  + "  http://github.com/" + bot_github_repo + '/issues/' + issue_number