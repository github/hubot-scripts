# Description
#   Trolls messages for the use of 'sneak peak', and prompts user for correction. Based on the brilliant @stealthmountain Twitter account.
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   "sneak peak" - responds with correction
#
# Author:
#   kylemac

module.exports = (robot) ->
  robot.hear /\s?(sneak peak)\s?/i, (msg) ->
    msg.send 'I think you mean "sneak peek"'
