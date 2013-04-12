# Description
#   Listens for vine links and embeds the gif version from gifvine.co
#
# Dependencies
#   None
#
# Configuration
#   None
#
# Commands:
#   None
#
# Notes:
#   None
#
# Author:
#   kyleslattery
module.exports = (robot) ->
  robot.hear /https?\:\/\/vine.co\/v\/([a-z0-9]+)/i, (msg) ->
    url = msg.match[0].replace("vine.co", "www.gifvine.co").replace("https", "http")

    msg.http(url)
      .get() (err, res, body) ->
        matches = body.match(/img src=\'([^\']+)\'/)
        gifurl = matches[1]
        msg.send gifurl + "#.gif"
