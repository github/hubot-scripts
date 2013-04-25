# Notifies about Jenkins build errors via Jenkins Notification Plugin
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/jenkins-notify?room=<room> to your Jenkins
#   Notification config. See here: https://wiki.jenkins-ci.org/display/JENKINS/Notification+Plugin
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/jenkins-notify?room=<room>[&type=<type>]
#
# Authors:
#   spajus

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/jenkins-notify", (req, res) ->

    @failing ||= []
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    envelope = {}
    envelope.user = {}
    envelope.room = query.room if query.room
    envelope.user.type = query.type if query.type

    try
      for key of req.body
        data = JSON.parse key

      if data.build.phase == 'FINISHED'
        if data.build.status == 'FAILURE'
          if data.name in @failing
            build = "is still"
          else
            build = "started"
          robot.send envelope, "#{data.name} build ##{data.build.number} #{build} failing (#{encodeURI(data.build.full_url)})"
          @failing.push data.name unless data.name in @failing
        if data.build.status == 'SUCCESS'
          if data.name in @failing
            index = @failing.indexOf data.name
            @failing.splice index, 1 if index isnt -1
            robot.send envelope, "#{data.name} build was restored ##{data.build.number} (#{encodeURI(data.build.full_url)})"

    catch error
      console.log "jenkins-notify error: #{error}. Data: #{req.body}"
      console.log error.stack

