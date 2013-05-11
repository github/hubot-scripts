# Description:
#   Evaluate one line of Ruby script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ruby|rb <script> - Evaluate one line of Ruby script
#
# Author:
#   jingweno

module.exports = (robot) ->
  robot.respond /(ruby|rb)\s+(.*)/i, (msg)->
    script = msg.match[2]

    msg.http("http://tryruby.org/levels/1/challenges/0")
      .query("cmd": script)
      .headers("Content-Length": "0")
      .put() (err, res, body) ->
        switch res.statusCode
          when 200
            result = JSON.parse(body)

            if result.success
              msg.reply result.output
            else
              msg.reply result.result
          else
            msg.reply "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"
