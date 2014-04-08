# Description:
#   Post
#   This script used in conjunction with tcWebHooks: http://tcplugins.sourceforge.net/info/tcWebHooks makes Hubot to send you build status messages.
#
#   Install web hooks, set this sucker up with Hubot, make sure you have a port configured for him, and set the HUBOT_ROOM_TO_RECEIVE_TEAM_CITY_BUILD_RESULTS
#   environment variable and Bob's your uncle you'll get build status messages from Hubot in your chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ROOM_TO_RECEIVE_TEAM_CITY_BUILD_RESULTS
#
# Commands:
#   None
#
# Notes:
#   All the properties available on the build object can be found at the properties list at the top of this file:
#   http://sourceforge.net/apps/trac/tcplugins/browser/tcWebHooks/trunk/src/main/java/webhook/teamcity/payload/format/WebHookPayloadJsonContent.java
#
# Author:
#   cubanx 

TextMessage = require('hubot').TextMessage

room = process.env.HUBOT_ROOM_TO_RECEIVE_TEAM_CITY_BUILD_RESULTS
unless room
  throw "Need a room to send build status messages to once we receive the web hook call"
module.exports = (robot)->
  robot.router.post "/hubot/build/", (req, res)->
    user = robot.brain.userForId 'broadcast'
    user.room = room
    user.type = 'groupchat'
    build = req.body.build

    robot.send user, "#{build.message} and ran on agent:#{build.agentName}"

    soundToPlay = 'http://soundfxnow.com/soundfx/Human-Cheer-SmallCrowd01.mp3'

    if build.buildResult == 'failure'
      failList = ["dog", "cat", "baby"]
      soundToPlay = 'http://soundfxnow.com/soundfx/Sad-Trombone.mp3'
      message = 'bing image fail ' + failList[Math.floor(Math.random() * failList.length)]
      robot.receive new TextMessage user, message

    robot.receive new TextMessage user, "hubot sound #{soundToPlay}"

    res.end "that tickles:" + process.env.PORT
