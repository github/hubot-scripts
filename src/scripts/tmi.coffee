# Description:
#   Too Much Information (TMI) Autoresponder
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   TMI words
#
# Author:
#   Bryan Burkholder

module.exports = (robot) ->
  robot.hear /baby|family|screaming|doctor|surgery|blood|dentist|chiropractor/i, (msg) ->
    msg.reply "TMI"
