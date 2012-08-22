# Description:
#   Renders an JSON array to spark graph
#
# Dependencies:
#   "textspark": "0.0.4"
#
# Configuration:
#   None
#
# Commands:
#   hubot spark me [1,2,3,4,5,6,7,3] - ouputs a spark rendered graph
#
# Author:
#   nesQuick

spark = require('textspark')

module.exports = (robot) ->
  robot.respond /spark me (.*)/i, (msg) ->
    msg.send spark JSON.parse msg.match[1]