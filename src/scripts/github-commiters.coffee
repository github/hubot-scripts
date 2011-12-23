# Show the commiters from a repo
#
# add HUBOT_GITHUB_USER to your heroku env 
# the HUBOT_GITHUB_USER should map to your account, not the bot account
# the HUBOT_BOT_GITHUB_USER should map to the bot github username
# the HUBOT_BOT_GITHUB_PASS should map to the bot github password

# developed by http://github.com/fellix - Crafters Software Studio

module.exports = (robot) ->
  robot.hear /^repo commiters (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          max_length = commits.length
          max_length = 20 if commits.length > 20
          for commit in commits
            msg.send "[#{commit.login}] #{commit.contributions}"
            max_length -= 1
            return unless max_length
              
  robot.hear /^repo top-commiter (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          top_commiter = null
          for commit in commits
            top_commiter = commit if top_commiter == null
            top_commiter = commit if commit.contributions > top_commiter.contributions 
          msg.send "[#{top_commiter.login}] #{top_commiter.contributions} :trophy:"
  
  
read_contributors = (msg, response_handler) ->
    repo = msg.match[1].toLowerCase()
    repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless repo.indexOf("/") > -1
    bot_github_user = process.env.HUBOT_BOT_GITHUB_USER 
    bot_github_pass = process.env.HUBOT_BOT_GITHUB_PASS
    auth = new Buffer("#{bot_github_user}:#{bot_github_pass}").toString('base64')
    url = "https://api.github.com/repos/#{repo}/contributors"
    
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
          response_handler commits
