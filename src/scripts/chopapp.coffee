# Description:
#   Return a link to your chopapp.com code
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot chop [me] [in] <language> <code> - Return a URL of your chopapp snippet (ruby, javascript, php, ...)
#
# Author:
#   kristofbc

module.exports = (robot) ->
	robot.respond /chop (me )?(in )?(\w+) (.*)$/i, (msg) ->
		getUrl(msg) 

getUrl = (msg) ->
	lang = escape(msg.match[3])
	code = escape(msg.match[4])

	# Exceptions
	if lang is 'javascript' or 'js'
		lang = 'java_script' # whut
	if lang is 'c++'
		lang = 'c'
	if lang is 'text'
		lang = 'diff'

	url = 'Drop+in+a+URL...' # default by chopapp
	params = 'code=' + code + '&language=' + lang + '&url=' + url
	msg.http('http://chopapp.com/code_snips')
		.headers("Accept:": "*/*", "Content-Type": "application/x-www-form-urlencoded", "Content-Length": params.length)
		.post(params) (err, res, body) ->
			if err
				message.send "Does not compute"
			else
				response = JSON.parse body
				msg.send "Here's your code: http://chopapp.com/#" + response.token
	