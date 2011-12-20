# Show open pull requests from a Github repository.
#
# You need to set the following variables:
#   HUBOT_GITHUB_TOKEN ="<oauth token>"
#   HUBOT_GITHUB_USER ="<user name>"
#
# HUBOT_GITHUB_USER is optional, but if you set it, you can ask `show me hubot pulls`
# instead of `show me github/hubot pulls`.
#
# You can further filter pull request title by providing a reguar expression. For exmaple,
# `show me hubot pulls with awesome fix`.
#
# show me <user/repo> pulls [with <regular expression>] - Shows open pull requests for that project by filtering pull request's title.
module.exports = (robot) ->
  robot.respond /show\s+(me\s+)?(.*)\s+pulls(\s+with\s+)?(.*)?/i, (msg)->
    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    repo = msg.match[2].toLowerCase()
    repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless ~repo.indexOf("/")
    filter_reg_exp = new RegExp(msg.match[4], "i") if msg.match[3]

    msg.http("https://api.github.com/repos/#{repo}/pulls")
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
      .query(state: "open")
      .get() (err, res, body) ->
        pulls = JSON.parse(body)

        if err || res.statusCode != 200
          msg.send "GitHub says: #{pulls.message}"
          return

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
