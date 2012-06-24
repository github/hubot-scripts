# Description:
#   Find the build status of an open-source project on Travis
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot travis me <user>/<repo> - Returns the build status of https://github.com/<user>/<repo>
#
# Author:
#   sferik

module.exports = (robot) ->
  robot.respond /travis me (.*)/i, (msg) ->
    project = escape(msg.match[1])
    msg.http("http://travis-ci.org/#{project}.json")
      .get() (err, res, body) ->
        response = JSON.parse(body)
        if response.last_build_status == 0
          msg.send "Build status for #{project}: Passing"
        else if response.last_build_status == 1
          msg.send "Build status for #{project}: Failing"
        else
          msg.send "Build status for #{project}: Unknown"
