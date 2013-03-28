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
#
# Author:
#   harukizaemon

module.exports = (robot) ->
  robot.hear /inconceivable/i, (msg) ->
    msg.send "You keep using that word. I do not think it means what you think it means."

  robot.hear /(inigo|montoya)/i, (msg) ->
    msg.send "Hello. My name is Inigo Montoya. You killed my father. Prepare to die."
