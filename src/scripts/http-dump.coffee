# Description:
#   "Accepts any request and dump post,query strings and headers for debugging purpose"
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   HUBOT_DUMP_ROOM
#
# Commands:
#   None
#
# URLs:
#   POST /hubot/dump
#
#
#   curl -X POST "http://hubotIp:hubotPort/hubot/dump?foo=bar&name=richard" -d myPost=stallman
#
# Author:
#   beygi

querystring = require('querystring')
url = require('url')

module.exports = (robot) ->
  robot.router.all "/hubot/dump", (req, res) ->
    room = process.env.HUBOT_DUMP_ROOM
    query = querystring.parse(url.parse(req.url).query)
 
    HEADERS = Object.keys(req.headers)
    POSTS = Object.keys(req.body)
    GETS = Object.keys(query)

    user = robot.brain.userForId 'broadcast'
    user.room = room
    user.type = 'groupchat'

    for headerData in HEADERS
      robot.send user, 'HEADER-> '+headerData+': "'+req.headers[headerData]+'"';    

    for postData in POSTS
      robot.send user, 'POST-> '+postData+': "'+req.body[postData]+'"';
    
    for getData in GETS
      robot.send user, "GET-> "+getData+': "'+query[getData]+'"';

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Request Compeleted\n'