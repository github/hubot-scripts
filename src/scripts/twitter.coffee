# Description:
#   gets tweet from user
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot twitter <twitter username> - Show last tweet from <twitter username>
#
# Author:
#   KevinTraver
#
module.exports = (robot) ->
  robot.respond /(twitter|lasttweet) (.+)$/i, (msg) ->
   username = msg.match[2]
   msg.http("http://api.twitter.com/1/statuses/user_timeline/#{escape(username)}.json?count=1&include_rts=true")
    .get() (err, res, body) ->
      response = JSON.parse body
      if response[0]
       msg.send response[0]["text"]
      else
       msg.send "Error"
