# Description:
#   An HTTP Listener for notifications on stash pushes
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/stash-commits?room=<room> into your stash hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/stash-commits?room=<room>[&type=<type]
#
# Authors:
#   Soren Mathiasen @sorenmat

url = require('url')
querystring = require('querystring')
gitio = require('gitio2')

module.exports = (robot) ->
  robot.router.post "/hubot/stash-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    res.end "Got it !"   
    console.log("Got request 'post': "+query)

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type
    
    try
      payload = req.body

      text = ""
      for value in payload.changesets.values
        repo = payload.repository.name
        msg = value.toCommit.message
        text = text + value.toCommit.author.name + " pushed '" + msg + "' to " + repo+"\n"
      
      robot.send user, text
    catch error
      console.log "stash-commits error: #{error}. Payload: #{req.body}"
