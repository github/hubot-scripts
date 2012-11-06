# Description:
#   Announce changes to GitHub repositories using GitHub's webhook service
#   to a room sepecified by the URL. This has only been tested with the
#   xmpp service.
#
# Dependencies:
#   None
#
# Configuration:
#   Enable a 'WebHook URL' under [repo admin] >> Service Hooks. Have it POST
#   to ${YOURHUBOTURL}:8080/hubot/github/${ROOM_NAME}. More documentation is
#   available at https://help.github.com/articles/post-receive-hooks .
#
# Author:
#   Steven Merrill, based on bitbucket.coffee by JRusbatch

module.exports = (robot) ->
  robot.router.post '/hubot/github/:room', (req, res) ->
    room = req.params.room

    data = JSON.parse req.body.payload
    commits = data.commits

    msg = "#{commits.length} commits were pushed to #{data.ref} in the '#{data.repository.name}' repository:\n\n"
    msg += "[#{commit.author.name}] #{commit.message}\n" for commit in commits

    robot.messageRoom room, msg

    res.writeHead 204, { 'Content-Length': 0 }
    res.end()
