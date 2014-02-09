# Description:
#   An HTTP Listener for notifications on github pushes
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#   "gitio2": "2.0.0"
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/gh-commits?room=<room> into you'r github hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/gh-commits?room=<room>[&type=<type]
#
# Authors:
#   nesQuick

url = require('url')
querystring = require('querystring')
gitio = require('gitio2')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = JSON.parse req.body.payload

      if payload.commits.length > 0
        commitWord = if payload.commits.length > 1 then "commits" else "commit"
        robot.send user, "Got #{payload.commits.length} new #{commitWord} from #{payload.commits[0].author.name} on #{payload.repository.name}"
        for commit in payload.commits
          do (commit) ->
            gitio commit.url, (err, data) ->
              robot.send user, "  * #{commit.message} (#{if err then commit.url else data})"
      else
        if payload.created
          robot.send user, "#{payload.pusher.name} created: #{payload.ref}: #{payload.base_ref}"
        if payload.deleted
          robot.send user, "#{payload.pusher.name} deleted: #{payload.ref}"

    catch error
      console.log "github-commits error: #{error}. Payload: #{req.body.payload}"

