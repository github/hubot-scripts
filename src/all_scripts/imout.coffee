# Description:
#   I'm out - mic drop
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   out, i'm out, im out - display mic drop gif
#
# Author:
#   jmabry

Client = require 'tag-cloud-client'

module.exports = (robot) ->
	robot.hear /\b(out|I'm out|i'm out|Im out|im out)\b/i, (msg) ->
		tag_cloud = new Client()
		tag_cloud.GetRandomValue 'out-images', (data)->
			msg.send data.value
