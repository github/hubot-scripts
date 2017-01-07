# Description:
#   Retrieves random blurb from Bacon Ipsum.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot baconipsum - Reply back with Bacon Ipsum text.
#
# Author:
#   kkost

module.exports = (robot) ->
	robot.respond /baconipsum$/i, (msg) ->
		msg.http('http://baconipsum.com/api/?type=meat-and-filler&paras=1&start-with-lorem=0')
            .get() (error, response, body) ->
                # passes back the complete reponse
                response = JSON.parse('\{\"facts\": ' + body + ', \"success\": \"true\"\}')
                if response.success == "true"
                	msg.send response.facts[0]
                else
                	msg.send "Unable to get bacon right now."
