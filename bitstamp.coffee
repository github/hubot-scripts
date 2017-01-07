# Description:
#   Retrieves ticker data from BitStamp
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bitstamp - Reply back with BitStamp ticket data
#
# Author:
#   kkost

module.exports = (robot) ->
	robot.respond /bitstamp/i, (msg) ->
		msg.http('https://www.bitstamp.net/api/ticker/')
            .get() (error, response, body) ->
                # passes back the complete reponse
                response = JSON.parse(body)
                if response.last ? "true"
                	msg.send "Last: $" + response.last + ", High: $" + response.high + ", Low: $" + response.low + ", Volume: " + response.volume
                else
                	msg.send "Unable to get bitstamp ticker data right now."
				
				
