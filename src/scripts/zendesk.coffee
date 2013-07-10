# Description:
#   Ask Zendesk for the current unsolved list of customer tickets
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ZENDESK_API_KEY
#	HUBOT_ZENDESK_USERNAME
#	HUBOT_ZENDESK_SUBDOMAIN
#
# Commands:
#   hubot zendesk list
#
# Author:
#   Bellspringsteen


subdomain= process.env.HUBOT_ZENDESK_SUBDOMAIN
username = process.env.HUBOT_ZENDESK_USERNAME
api_key = process.env.HUBOT_ZENDESK_API_KEY
ids_previously_reported = []
url  = 'https://'+subdomain+'.zendesk.com/api/v2/'
set_interval_id = 0


getRequest = (robot,path, callback) ->
  auth = 'Basic ' + new Buffer(username+'/token:'+api_key).toString('base64')
  robot.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)


module.exports = (robot) ->
	poll = ->
		getRequest robot,'search.json?query="status<solved"', (err, res, body) ->
			current_ids = []
			response = JSON.parse body
			if response.results
				for ticket in response.results
					if (ticket.id not in ids_previously_reported)
						ids_previously_reported.push ticket.id
						robot.send "broadcast", "Ticket URL "+ticket.url+" with subject "+ticket.subject+" with description "+ticket.description
					current_ids.push ticket.id
				ids_previously_reported = current_ids
			else
				robot.send "broadcast", "So Sorry, We had an error"
    

	
	
	robot.respond /zendesk list/i, (msg) ->
		getRequest robot,'search.json?query="status<solved"', (err, res, body) ->
			response = JSON.parse body
			if response.results
				if (response.results.length == 0)
					msg.send "There are no unresolved tickets"
				for ticket in response.results
					msg.send "Ticket URL "+ticket.url+" with subject "+ticket.subject+" with description "+ticket.description
			else
				msg.send "So Sorry, We had an error"
	
	robot.respond /zendesk start polling/i, (msg) ->
		set_interval_id = setInterval(poll,600000)
		msg "polling started"
		
	robot.respond /zendesk stop polling/i, (msg) ->
		if (set_interval_id != 0)
			clearInterval(set_interval_id)
			msg "polling stopped"
		else 
			msg " Error, polling not started"
			
		