# Start up some wonderful chats with conversation starters
#
# chat - Tell hubot to make something fun to chat about
# Conversation starters graciously provided by http://Chatoms.com

module.exports = (robot) ->
  robot.respond /chat/i, (msg) ->
    msg.http("http://chatoms.com/chatom.json?Normal=1&Fun=2&Philosophy=3&Out+There=4&Love=5&Personal=7")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).text
