# Description:
#   A way to check github's server status
#
# Commands:
#   hubot github status - Return the current status of Github according to their own Status API.

module.exports = (robot) ->
  robot.respond /(github|gh) (status|st)/i, (msg) ->
    githubStatus msg, (status) ->
      msg.send status

githubStatus = (msg, cb) ->
  msg.http('https://status.github.com/api/last-message.json')
    .get() (err, res, body) ->
      cb JSON.parse(body).body

