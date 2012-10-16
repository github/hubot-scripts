# Description:
#  Listens for "standup" keywords and replys with Google Hangout url
#  To generate a static Hangout URL, create a Google + event sometime in the future
#
# Configuration:
#   HUBOT_HANGOUT_URL
#
# Author:
#   nicoritschel
#

module.exports = (robot) ->
  robot.hear /standup|stand-up|hangout/i, (msg) ->
    process.env.HUBOT_HANGOUT_URL
    msg.send url
