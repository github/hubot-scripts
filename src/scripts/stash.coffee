# Description:
#   Accepts Atlassian Stash post commit webhook POSTs and delivers to chat
#
# Dependencies:
#   None
#
# Configurations:
#   HUBOT_CAMPFIRE_ROOMS - set the room(s) you want the message to go to
#
# Commands:
#
# Notes:
#   Instructions for configuring stash are here: https://confluence.atlassian.com/display/STASH/POST+service+webhook+for+Stash
#
# Author:
#   Kyle Guichard (kgsharp)

module.exports = (robot) ->
  room = process.env.HUBOT_CAMPFIRE_ROOMS

  robot.router.post '/stash', (req, res) ->
    jsonstring = JSON.stringify(req.body)
    message = JSON.parse jsonstring
    robot.logger.info "Received stash message: '#{jsonstring}' received"

    #set up response to campfire
    unless room
      robot.logger.error 'Please set the HUBOT_CAMPFIRE_ROOMS variable to post the message'
      return
    user = robot.brain.userForId 'broadcast'
    user.room = room
    user.type = 'groupchat'
    robot.send user, "Received stash post commit: \n
        Repository: #{message.repository.project.name} (#{message.repository.project.description}) \n
        Changes: \n
        #{i.link.url for i in message.changesets.values}"

    #respond to request
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks'
