# Description:
#   Interact with your Jenkins CI server
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JENKINS_URL
#   HUBOT_JENKINS_AUTH - Jenkins auth token (base64 encoded) to generate : echo "user:password" | base64
#
# Commands:
#   hubot jenkins build <job> - builds the specified Jenkins job
#   hubot jenkins build <job>, <params> - builds the specified Jenkins job with parameters as key=value&key2=value2
#   hubot jenkins list - lists Jenkins jobs
#
# Author:
#   dougcole

querystring = require 'querystring'

jenkinsBuild = (msg) ->
    url = process.env.HUBOT_JENKINS_URL
    job = querystring.escape msg.match[1]
    params = msg.match[3]

    path = if params then "#{url}/job/#{job}/buildWithParameters?#{params}" else "#{url}/job/#{job}/build"

    req = msg.http(path)

    if process.env.HUBOT_JENKINS_AUTH
      auth = process.env.HUBOT_JENKINS_AUTH
      req.headers Authorization: "Basic #{auth}"

    req.header('Content-Length', 0)
    req.post() (err, res, body) ->
        if res.statusCode == 401
           return;
        if err
          msg.send "Jenkins says: #{err}"
        else if res.statusCode == 302
          msg.send "Build started for #{job} #{res.headers.location}"
        else
          msg.send "Jenkins says: #{res.statusCode} #{body}"

jenkinsList = (msg) ->
    url = process.env.HUBOT_JENKINS_URL
    job = msg.match[1]
    req = msg.http("#{url}/api/json")

    if process.env.HUBOT_JENKINS_AUTH
      auth = process.env.HUBOT_JENKINS_AUTH
      req.headers Authorization: "Basic #{auth}"

    req.get() (err, res, body) ->
        if res.statusCode == 401
           return;
        response = ""
        if err
          msg.send "Jenkins says: #{err}"
        else
          try
            content = JSON.parse(body)
            for job in content.jobs
              state = if job.color == "red" then "FAIL" else "PASS"
              response += "#{state} - #{job.name}\n"
            msg.send response
          catch error
            msg.send error

module.exports = (robot) ->
  robot.respond /jenkins build ([\w\.\-_ ]+)(, (.+))?/i, (msg) ->
    jenkinsBuild(msg)

  robot.respond /jenkins list/i, (msg) ->
    jenkinsList(msg)

  robot.jenkins = {
    list: jenkinsList,
    build: jenkinsBuild
  }