# Description:
#   Announce changes to BitBucket repositories using BitBucket's POST service
#   to a room sepecified by the URL.
# 
# Dependencies:
#   None
#
# Configuration:
#   For instructions on how to set up BitBucket's POST service for your
#   repositories, visit:
#   http://confluence.atlassian.com/display/BITBUCKET/Setting+Up+the+bitbucket+POST+Service
#
# Author:
#   JRusbatch

module.exports = (robot) ->
  robot.router.post '/hubot/bitbucket/:room', (req, res) ->
    room = req.params.room
    
    data = JSON.parse req.body.payload
    commits = data.commits
      
    msg = "#{data.user} pushed #{commits.length} commits to #{data.repository.name}:\n\n"
    msg += "[#{commit.branch}] #{commit.message}\n" for commit in commits
    
    robot.messageRoom room, msg
      
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()
