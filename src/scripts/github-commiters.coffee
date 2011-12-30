# Show the commiters from a repo
#
# You need to set the following variables:
#   HUBOT_GITHUB_TOKEN ="<oauth token>"
#
# developed by http://github.com/fellix - Crafters Software Studio

module.exports = (robot) ->
  robot.respond /repo commiters (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          max_length = commits.length
          max_length = 20 if commits.length > 20
          for commit in commits
            msg.send "[#{commit.login}] #{commit.contributions}"
            max_length -= 1
            return unless max_length
              
  robot.respond /repo top-commiter (.*)$/i, (msg) ->
      read_contributors msg, (commits) ->
          top_commiter = null
          for commit in commits
            top_commiter = commit if top_commiter == null
            top_commiter = commit if commit.contributions > top_commiter.contributions 
          msg.send "[#{top_commiter.login}] #{top_commiter.contributions} :trophy:"
  
  
read_contributors = (msg, response_handler) ->
    repo = msg.match[1].toLowerCase()
    repo = "#{process.env.HUBOT_GITHUB_USER}/#{repo}" unless repo.indexOf("/") > -1
    oauth_token = process.env.HUBOT_GITHUB_TOKEN
    url = "https://api.github.com/repos/#{repo}/contributors"
    
    msg.http(url)
      .headers(Authorization: "token #{oauth_token}", Accept: "application/json")
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
