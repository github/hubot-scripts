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
#   POST /hubot/jenkins-notify?room=<room>[&type=<type>][&notstrat=<notificationSTrategy>]
#
# Notification Strategy is [Ff][Ss] which stands for "Failure" and "Success"
# Capitalized letter means: notify always
# small letter means: notify only if buildstatus has changed
# "Fs" is the default
# 
# Authors:
#   spajus
#   k9ert (notification strategy feature)

url = require('url')
querystring = require('querystring')

buildStatusChanged = (data, @failing) ->
  if data.build.status == 'FAILURE' and data.name in @failing
    return false
  if data.build.status == 'FAILURE' and not (data.name in @failing)
    return true
  if data.build.status == 'SUCCESS' and data.name in @failing
    return true
  if data.build.status == 'SUCCESS' and not (data.name in @failing)
    return false
  console.log "this should not happen"

shouldNotify = (notstrat, data, @failing) ->
  if data.build.status == 'FAILURE'
    if /F/.test(notstrat)
      return true
    return buildStatusChanged(data, @failing)
  if data.build.status == 'SUCCESS'
    if /S/.test(notstrat)
      return true
    return buildStatusChanged(data, @failing)
      

module.exports = (robot) ->

  robot.router.post "/hubot/jenkins-notify", (req, res) ->

    @failing ||= []
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    envelope = {notstrat:"Fs"}
    envelope.room = query.room if query.room
    envelope.notstrat = query.notstrat if query.notstrat 
    if query.type
      envelope.user = {type: query.type}

    try
      data = req.body

      if data.build.phase == 'FINISHED'
        if data.build.status == 'FAILURE'
          if data.name in @failing
            build = "is still"
          else
            build = "started"
          robot.send envelope, "#{data.name} build ##{data.build.number} #{build} failing (#{encodeURI(data.build.full_url)})" if shouldNotify(envelope.notstrat, data, @failing)
          @failing.push data.name unless data.name in @failing
        if data.build.status == 'SUCCESS'
          if data.name in @failing
            build = "was restored"
          else
            build = "succeeded"
          robot.send envelope, "#{data.name} build ##{data.build.number} #{build} (#{encodeURI(data.build.full_url)})"  if shouldNotify(envelope.notstrat, data, @failing)
          index = @failing.indexOf data.name
          @failing.splice index, 1 if index isnt -1

    catch error
      console.log "jenkins-notify error: #{error}. Data: #{req.body}"
      console.log error.stack

