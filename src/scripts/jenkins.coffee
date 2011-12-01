# Interact with your jenkins CI server, assumes you have a parameterized build
# with the branch to build as a parameter
#
# You need to set the following variables:
#   HUBOT_JENKINS_URL = "http://ci.example.com:8080"
# 
# The following variables are optional
#   HUBOT_JENKINS_JOB: if not set you will have to specify job name every time
#   HUBOT_JENKINS_BRANCH_PARAMETER_NAME: if not set is assumed to be BRANCH_SPECIFIER
#   HUBOT_JENKINS_AUTH: for authenticating the trigger request (user:apiToken)
#
# build branch master - starts a build for branch origin/master
# build branch master on job Foo - starts a build for branch origin/master on job Foo
module.exports = (robot) ->
  robot.respond /build\s*(branch\s+)?([\w\/-]+)(\s+(on job)?\s*([\w-]+))?/i, (msg) ->

    url = process.env.HUBOT_JENKINS_URL

    job = msg.match[5] || process.env.HUBOT_JENKINS_JOB
    job_parameter = process.env.HUBOT_JENKINS_BRANCH_PARAMETER_NAME || "BRANCH_SPECIFIER"

    branch = msg.match[2]
    branch = "origin/#{branch}" unless ~branch.indexOf("/")

    json_val = JSON.stringify parameter: [{name: job_parameter, value: branch}]

    req = msg.http("#{url}/job/#{job}/build/api/json")

    if process.env.HUBOT_JENKINS_AUTH
      auth = new Buffer(process.env.HUBOT_JENKINS_AUTH).toString('base64')
      req.headers Authorization: "Basic #{auth}"

    req.headers 'Content-Type': 'application/x-www-form-urlencoded'
    req.post("json=#{json_val}") (err, res, body) ->
        if err
          msg.send "Jenkins says: #{err}"
        else if res.statusCode == 302
          msg.send "Build started for #{branch}! #{res.headers.location}"
        else
          msg.send "Jenkins says: #{body}"

