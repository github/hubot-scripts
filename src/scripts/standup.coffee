# Description:
#  Listens for "standup" keywords and speaks Google Hangout url. Saves a couple minutes in our office.
#
# Configuration:
#   HUBOT_HANGOUT_URL
#
# Commands:
#   <standup> - speaks hangout url
#
# Notes:
#  To generate a static Hangout URL, create a Google + event sometime in the future
#
# Author:
#   nicoritschel

module.exports = (robot) ->
  robot.hear /standup|stand-up|hangout/i, (msg) ->
    msg.send process.env.HUBOT_HANGOUT_URL
