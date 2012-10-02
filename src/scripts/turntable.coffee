# Description
#   Informs about songs played and chat in a turntable.fm room.
#
# Dependencies:
#   "ttapi": "1.5.0"
#
# Configuration:
#   TT_AUTH - turntable.fm auth
#   TT_USERID - turntable.fm user id
#   TT_ROOMID - turntable.fm room id
#   TT_CHAN - Hubot channel to send messages to
#
# Commands:
#   None
#
# Notes:
#   See https://github.com/alaingilbert/Turntable-API
#
# Author:
#   mmb

module.exports = (robot) ->
  env = process.env

  if env.TT_AUTH and env.TT_USERID and env.TT_ROOMID and env.TT_CHAN
    ttapi = require 'ttapi'
    ttbot = new ttapi env.TT_AUTH, env.TT_USERID, env.TT_ROOMID

    newsong_callback = (data) ->
      song = data.room.metadata.current_song

      robot.messageRoom env.TT_CHAN,
        "#{song.djname}@turntable.fm played '#{song.metadata.song}' by '#{song.metadata.artist}'"

    ttbot.on 'newsong', newsong_callback

    speak_callback = (data) ->
      robot.messageRoom env.TT_CHAN, "#{data.name}@turntable.fm: #{data.text}"

    ttbot.on 'speak', speak_callback
  else
    console.log 'Set the TT_AUTH, TT_USERID, TT_ROOMID and TT_CHAN environment variables to enable the turntable.fm script'
