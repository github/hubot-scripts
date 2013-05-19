# Description:
#   Hubot, be Swissy and enjoy team exults.
#   Whenever TIP TOP or TOP is being said Hubot will reply back.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#   Consecutive hops will be ignored.
#
# Author:
#   matteoagosti

module.exports = (robot) ->
  robot.hear /.+/i, (msg) ->
    unless msg.message.text is "TOP" or msg.message.text is "TIP TOP"
      robot.brain.data.tiptop = null
      return

    unless robot.brain.data.tiptop is null
      return

    msg.send msg.message.text
    robot.brain.data.tiptop = true