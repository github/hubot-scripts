# Description:
#   DBA Reactions
#
# Dependencies:
#   "string": "~1.8.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot dba me - A randomly selected photo and caption from dbareactions.com
#   hubot dba bomb <number> - Explostion of random dba reactions, defaults to 5.
#
# Author:
#   @AgentO3

S = require('string');

url = 'http://dbareactions.com/api/read/json?debug=1&type=photo&num=50'

module.exports = (robot) ->
  robot.respond /dba?(?: me)?$/i, (msg) ->
    reqPics(url, msg, 1)

  robot.respond /dba bomb( (\d+))?/i, (msg) ->
  	count = msg.match[1] || 5
  	reqPics(url, msg, count)

reqPics = (url, msg, count) ->
  msg.http(url)
  .get() (err, res, body) ->
  	(sendMessage(JSON.parse(body).posts, msg)) for i in [1..count]

sendMessage = (posts, msg) ->
	pick = msg.random(posts)
	msg.send pick["photo-url-400"]
	msg.send S(pick["photo-caption"]).stripTags().decodeHTMLEntities().s

