# Description:
#   An HTTP Listener that notifies about new Github pull requests
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   You will have to do the following:
#   1. Get an API token: curl -u 'username' -d '{"scopes":["repo"],"note":"Hooks management"}' \
#                         https://api.github.com/authorizations
#   2. Add <HUBOT_URL>:<PORT>/hubot/gh-pull-requests?room=<room>[&type=<type>] url hook via API:
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
#
# Notes:
#   Room information can be obtained by hubot-script: room-info.coffee
#   Room must be in url encoded format (i.e. encodeURIComponent("yourRoomInfo"))


url = require('url')
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/gh-pull-requests", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    data = req.body
    room = query.room

    try
      announcePullRequest data, (what) ->
        robot.messageRoom room, what
    catch error
      robot.messageRoom room, "Whoa, I got an error: #{error}"
      console.log "github pull request notifier error: #{error}. Request: #{req.body}"

    res.end ""


announcePullRequest = (data, cb) ->
  if data.action == 'opened'
    mentioned = data.pull_request.body?.match(/(^|\s)(@[\w\-\/]+)/g)

    if mentioned
      unique = (array) ->
        output = {}
        output[array[key]] = array[key] for key in [0...array.length]
        value for key, value of output

      mentioned = mentioned.filter (nick) ->
        slashes = nick.match(/\//g)
        slashes is null or slashes.length < 2

      mentioned = mentioned.map (nick) -> nick.trim()
      mentioned = unique mentioned

      mentioned_line = "\nMentioned: #{mentioned.join(", ")}"
    else
      mentioned_line = ''

    cb "New pull request \"#{data.pull_request.title}\" by #{data.pull_request.user.login}: #{data.pull_request.html_url}#{mentioned_line}"
