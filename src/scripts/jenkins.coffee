# Interact with your Jenkins CI server
#
# You need to set the following variables:
#   HUBOT_JENKINS_URL = "http://ci.example.com:8080"
#
# The following variables are optional
#   HUBOT_JENKINS_AUTH: for authenticating the trigger request (user:password)
#
# jenkins build <job> - builds the specified Jenkins job
# jenkins build <job> with <params> - builds the specified Jenkins job with parameters as key=value&key2=value2
# jenkins list - lists Jenkins jobs
#
module.exports = (robot) ->
  robot.respond /jenkins build ([\w\.\-_]+)( with (.+))?/i, (msg) ->

    url = process.env.HUBOT_JENKINS_URL
    job = msg.match[1]
    params = msg.match[3]

    path = if params then "#{url}/job/#{job}/buildWithParameters?#{params}" else "#{url}/job/#{job}/build"

    req = msg.http(path)

    if process.env.HUBOT_JENKINS_AUTH
      auth = new Buffer(process.env.HUBOT_JENKINS_AUTH).toString('base64')
      req.headers Authorization: "Basic #{auth}"

    req.header('Content-Length', 0)
    req.post() (err, res, body) ->
        if err
          msg.send "Jenkins says: #{err}"
        else if res.statusCode == 302
          msg.send "Build started for #{job} #{res.headers.location}"
        else
          msg.send "Jenkins says: #{body}"


  robot.respond /jenkins list/i, (msg) ->

    url = process.env.HUBOT_JENKINS_URL
    job = msg.match[1]
    req = msg.http("#{url}/api/json")

    if process.env.HUBOT_JENKINS_AUTH
      auth = new Buffer(process.env.HUBOT_JENKINS_AUTH).toString('base64')
      req.headers Authorization: "Basic #{auth}"

    req.get() (err, res, body) ->
        response = ""
        if err
          msg.send "Jenkins says: #{err}"
        else
          try
            content = JSON.parse(body)
            for job in content.jobs
              state = if job.color == "red" then "FAIL" else "PASS"
              response += "#{state} #{job.name}\n"
            msg.send response
          catch error
            msg.send error
