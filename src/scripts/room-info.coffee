# Description:
#   Tells what room is this. Especially convenient with Skype adapter.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot room info - gives some information about current room
#
# Authors:
#   spajus

module.exports = (robot) ->

  robot.hear /room info/i, (msg) ->
    msg.send "This room is: #{msg.message.room}"

