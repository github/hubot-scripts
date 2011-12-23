# it was based on github-issues.coffee script
# 
# add "date-utils":">=1.2.5" in the hubot-scripts.json file
#
# add HUBOT_GITHUB_USER to your heroku env 
# the HUBOT_GITHUB_USER should map to your account, not the bot account
# the HUBOT_BOT_GITHUB_USER should map to the bot github username
# the HUBOT_BOT_GITHUB_PASS should map to the bot github password
# (you do not need to create a bot github account, but doing keeps your account secure)
#
# developed by http://github.com/vquaiato - Crafters Software Studio

require('date-utils')

module.exports = (robot) ->
  robot.hear /^repo show (.*)$/i, (msg) ->
    repo = msg.match[1].toLowerCase()
    repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless repo.indexOf("/") > -1
    bot_github_user = process.env.HUBOT_BOT_GITHUB_USER
    bot_github_pass = process.env.HUBOT_BOT_GITHUB_PASS
    auth = new Buffer("#{bot_github_user}:#{bot_github_pass}").toString('base64')
    url = "https://api.github.com/repos/#{repo}/commits"

    msg.http(url)
      .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "GitHub says: #{err}"
          return
        commits = JSON.parse(body)
        if commits.message
          msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
        else if commits.length == 0
            msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
        else
          msg.send "http://github.com/#{repo}"
          send = 5
          for c in commits
            if send
              d = new Date(Date.parse(c.commit.committer.date)).toFormat("DD/MM HH24:MI")
              msg.send "[#{d} -> #{c.commit.committer.name}] #{c.commit.message}" 
              send -= 1