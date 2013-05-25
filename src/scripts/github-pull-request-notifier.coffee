# Description:
#   An HTTP Listener that notifies about new Github pull requests
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   You will have to do the following:
#   1. Test your room/type configuration using "hubot test pull request in <room> [type]"
#   2. Get an API token: curl -u 'username' -d '{"scopes":["repo"],"note":"Hooks management"}' \
#                         https://api.github.com/authorizations
#   3. Add <HUBOT_URL>:<PORT>/hubot/gh-pull-requests?room=<room>[&type=<type>] url hook via API:
#      curl -H "Authorization: token <your api token>" \
#      -d '{"name":"web","active":true,"events":["pull_request"],"config":{"url":"<this script url>","content_type":"json"}}' \
#      https://api.github.com/repos/<your user>/<your repo>/hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/gh-pull-requests?room=<room>[&type=<type]
#
# Authors:
#   spajus

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-pull-requests", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      announcePullRequest req.body, (what) ->
        robot.send user, what
    catch error
      console.log "github pull request notifier error: #{error}. Request: #{req.body}"

announcePullRequest = (data, cb) ->
  if data.action == 'opened'
    cb "New pull request \"#{data.pull_request.title}\" by #{data.pull_request.user.login}: #{data.pull_request.html_url}"


