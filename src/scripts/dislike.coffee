# Description:
#   Grumpy cat dislike this >:[
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   nesQuick

module.exports = (robot) ->
  robot.hear /dislike/i,{id: 'dislike.get'}, (msg) ->
    msg.send "https://pbs.twimg.com/media/BFV2RuQCUAArpAs.jpg"
