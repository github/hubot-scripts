# Description:
#   aw yiss
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot aw yiss <text> - motha fuckin <text>
#
# Author:
#   sschneid

module.exports = (robot) ->
  robot.hear /aw+ yiss+,? (.+)/i, (msg) ->
    data = "phrase=#{msg.match[1]}"
    msg
      .http("http://awyisser.com/api/generator")
      .header("Content-Type","application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        body = JSON.parse(body)
        msg.send body.link
