# Description:
#   Beanstalk tools
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BEANSTALK_SUBDOMAIN
#   HUBOT_BEANSTALK_ACCOUNT
#   HUBOT_BEANSTALK_PASSWORD
#
# Commands:
#   beanstalk repositories - List beanstalk repositories
#   beanstalk commits - List beanstalk recent commits
#   beanstalk users - List beanstalk users
#   beanstalk deployments - List beanstalk recent deployments
#
# Author:
#   eliperkins

module.exports = (robot) ->

  robot.respond /beanstalk repositories/i, (msg) ->
    beanstalk_request msg, 'api/repositories.json', (repositories) ->
      if repositories.count <= 0
        msg.send "No repositories found for this account"
        return
        
      for child in repositories
        repository = child.repository
        msg.send "#{repository.name} (#{repository.vcs}) -> Last commit: #{repository.last_commit_at}"
      
  robot.respond /beanstalk commits/i, (msg) ->
    beanstalk_request msg, 'api/changesets.json', (changesets) ->

      if changesets.count <= 0
        msg.send "No changesets found for this account"
        return
        
      repositories = [ ]
      beanstalk_request msg, 'api/repositories.json', (result) ->
        for child in result
          repositories["#{child.repository.id}"] = child.repository	
        
        for child in changesets
          changeset = child.revision_cache
          msg.send repositories["#{changeset.repository_id}"].name + " -> Committed: #{changeset.time} by #{changeset.author}"
      
  robot.respond /beanstalk users/i, (msg) ->
    beanstalk_request msg, 'api/users.json', (users) ->

      if users.count <= 0
        msg.send "No users found for this account"
        return

      for child in users
        user = child.user
        role = if user.owner then "owner" else if user.admin then "admin" else "user"
        msg.send "#{user.first_name} #{user.last_name} (#{user.email}) -> Role: #{role} Joined: #{user. created_at}"
      
  robot.respond /beanstalk deployments/i, (msg) ->
    beanstalk_request msg, 'api/releases.json', (deployments) ->

      if deployments <= 0
        msg.send "No deployments found for this account"
        return
        
      repositories = [ ]
      beanstalk_request msg, 'api/repositories.json', (result) ->
        for child in result
          repositories["#{child.repository.id}"] = child.repository	
        
        for child in deployments
          deployment = child.release
          msg.send repositories["#{deployment.repository_id}"].name + " deployed to #{deployment.environment_name} on #{deployment.created_at}"

  beanstalk_request = (msg, url, handler) ->
    auth = new Buffer("#{process.env.HUBOT_BEANSTALK_ACCOUNT}:#{process.env.HUBOT_BEANSTALK_PASSWORD}").toString('base64')
    beanstalk_url = "https://#{process.env.HUBOT_BEANSTALK_SUBDOMAIN}.beanstalkapp.com"
    msg.http("#{beanstalk_url}/#{url}")
      .headers(Authorization: "Basic #{auth}", Accept: "application/json")
        .get() (err, res, body) ->
          if err
            msg.send "Beanstalk says: #{err}"
            return
          content = JSON.parse(body)
          if content.errors
            msg.send "Beanstalk says: #{content.errors[0]}"
            return
          handler content
