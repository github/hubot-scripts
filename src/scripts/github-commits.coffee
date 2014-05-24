# Description:
#   An HTTP Listener for notifications on github pushes
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#   "gitio2": "2.0.0"  (optional)
#
# Configuration:
#   Put this url <HUBOT_URL>:<PORT>/hubot/gh-commits?room=<room> into your GitHub hooks
#   HUBOT_GITIO
#     Set nonempty for shortened URLs.  If not unset or empty, you
#     don't need gitio2.
#   HUBOT_GITHUB_API
#     Optional, default is https://api.github.com. Override with
#     http[s]://yourdomain.com/api/v3/ for Enterprise installations.
#   HUBOT_COMMIT_ONELINE
#     Set nonempty to only show the summary lines.  If not unset or
#     empty, show the full message.
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
if process.env.HUBOT_GITIO
  gitio = require('gitio2')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.send 200

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    return if req.body.zen? # initial ping
    push = req.body

    try
      if push.commits.length > 0
        commitWord = if push.commits.length > 1 then "commits" else "commit"
        robot.send user, "Got #{push.commits.length} new #{commitWord} from #{push.commits[0].author.name} on #{push.repository.name}"
        for commit in push.commits
          do (commit) ->
            if process.env.HUBOT_GITIO
              gitio commit.url, (err, data) ->
                if not err
                  commit.url = data
            else
              if process.env.HUBOT_GITHUB_API
                commit.url = commit.url.replace(/api\/v3\//,'')
              else
                commit.url = commit.url.replace(/api\./,'')
              commit.url = commit.url.replace(/repos\//,'')
              commit.url = commit.url.replace(/commits/,'commit')
            if process.env.HUBOT_COMMIT_ONELINE
              commit.message = commit.message.split("\n")[0] + "\n"
            robot.send user, "* #{commit.message}  (#{commit.url})"
      else
        if push.created
          robot.send user, "#{push.pusher.name} created: #{push.ref}: #{push.base_ref}"
        if push.deleted
          robot.send user, "#{push.pusher.name} deleted: #{push.ref}"

    catch error
      console.log "github-commits error: #{error}. Push: #{push}"

