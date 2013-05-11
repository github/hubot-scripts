# Description:
#   Bring forth zombies
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   (zombie) - Call in a zombie
#
# Author:
#   solap

Client = require 'tag-cloud-client'

module.exports = (robot) ->
  robot.hear /zombi(e|es)/i, (msg) ->
    tag_cloud = new Client()
    tag_cloud.GetRandomValue 'zombie-images', (data)->
      msg.send data.value
