# Description
#   This script will display the current number and types of dynos in use for a Heroku app.
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_HEROKU_API_TOKEN
#
# Commands:
#   hubot dynos <app name> - responds with "There are x web dynos and y worker dynos"
#
# Notes:
#  This script assumes at least one web dyno and is intended to be used with apps that leverage auto-scaling 
#  features like HireFire where the number of dynos can change at any give point in time.
#
# Author:
#   aglover
module.exports = (robot) ->
  robot.respond /dynos (.*)/i, (msg) ->
  	token = 'Basic ' + new Buffer(':' + process.env.HUBOT_HEROKU_API_TOKEN).toString('base64')
  	msg.http("https://api.heroku.com/apps/#{escape(msg.match[1])}/dynos")
  	.headers(Authorization: token, Accept: 'application/vnd.heroku+json; version=3')
  	.get() (err, res, body) ->

  		response = JSON.parse(body)
  		[web, worker] = [0,0]

  		for dynoDoc in response
  			if dynoDoc.type == 'web' then web++ else worker++

  		webMessage = if web > 1 then "There are #{web} web dynos" else "There is 1 web dyno"

  		if worker > 1
  			workerMessage = "#{worker} worker dynos"
  		else if worker == 1
  			workerMessage = "1 worker dyno"
  		else
  			workerMessage = "no worker dynos"
  		   	
  		msg.send "#{webMessage} and #{workerMessage}"





