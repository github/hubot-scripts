# Description:
#  Listens for "hangout" keywords and speaks Google Hangout url. Saves a couple minutes in our office.
#
# Configuration:
#   HUBOT_HANGOUT_URL
#
# Commands:
#   hubot hangout - sends hangout url
#
# Notes:
#  To generate a static Hangout URL, create a Google+ event sometime in the future
#  @ https://plus.google.com/events
#
# Author:
#   nicoritschel

module.exports = (robot) ->
  robot.listen /hangout(.*)/i, (msg) ->
    if HUBOT_HANGOUT_URL
      msg.send process.env.HUBOT_HANGOUT_URL
    else
      msg.send "Environment variable HUBOT_HANGOUT_URL has not been set. Add EXPORT HUBOT_HANOUT_URL="..." to your profile"
