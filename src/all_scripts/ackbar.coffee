# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   trap - Display an Admiral Ackbar piece of wonder
#
# Author:
#   brilliantfantastic

Client = require 'tag-cloud-client'

module.exports = (robot) ->
  robot.hear /it'?s a trap\b/i, (msg) ->
    tag_cloud = new Client()
    tag_cloud.GetRandomValue 'ackbar-images', (data)->
      msg.send data.value
