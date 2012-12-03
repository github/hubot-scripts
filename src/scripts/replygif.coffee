# Description:
#   Makes ReplyGif easier to use. See http://replygif.net.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   http://replygif.net/<id> - Embeds image from ReplyGif with that id.
#   hubot replygif <keyword> - Embeds random ReplyGif with the keyword.
#   hubot replygif me <keyword> - Same as `hubot replygif <keyword>`.
# 
# Notes:
#   Thanks to What Cheer (@whatcheer) for providing the keyword lookup app.
#
# Author:
#   sumeetjain

module.exports = (robot) ->
  # Listen for someone to link to a ReplyGif and reply with the image.
  robot.hear /.*replygif\.net\/(i\/)?(\d+).*/i, (msg) ->
    id = msg.match[2]
    msg.send "http://replygif.net/i/#{id}#.gif"
    
  # Listen for a command to look up a ReplyGif by ID.
  robot.respond /replygif( me)? (\d+)/i, (msg) ->
    id = msg.match[2]
    msg.send "http://replygif.net/i/#{id}#.gif"
    
  # Listen for a command to look up a ReplyGif by tag.
  robot.respond /replygif( me)? (\D+)/i, (msg) ->
    tag = msg.match[2]
    msg.send "http://apps.whatcheerinc.com/replygif/#{tag}.gif"