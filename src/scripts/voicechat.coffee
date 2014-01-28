# Description:
#	Voice Chat API is an open-source audio conferencing app exposed via an API.
#	This plugin makes a GET request to fetch a URL where you can do a simple
#	WebRTC-powered audio call in browsers. The room will last for the next 24
#	hours. VoiceChatAPI Learn more on http://VoiceChatAPI.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot conference - create an audio chat room.
#
# Author:
#   DHfromKorea <dh@dhfromkorea.com>

module.exports = (robot) ->
  robot.respond /(conference)/i, (msg) ->
    msg.http('http://www.voicechatapi.com/api/v1/bridge/')
       .get() (err, res, body) ->
         json = JSON.parse(body)
         msg.send "Your conference room: #{json.conference_url} \n*Be careful when scheduling a call. This room will be automatically removed after 24 hours."
