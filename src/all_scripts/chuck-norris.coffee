# Description:
#   Chuck Norris awesomeness
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot chuck norris -- random Chuck Norris awesomeness
#   hubot chuck norris me <user> -- let's see how <user> would do as Chuck Norris
#
# Author:
#   dlinsin

module.exports = (robot) ->

  robot.respond /(chuck norris)( me )?(.*)/i, (msg)->
    user = msg.match[3]
    if user.length == 0
      askChuck msg, "http://api.icndb.com/jokes/random"
    else
      askChuck msg, "http://api.icndb.com/jokes/random?firstName="+user+"&lastName="
  
  askChuck = (msg, url) ->
    msg.http(url)
      .get() (err, res, body) ->
        if err
          msg.send "Chuck Norris says: #{err}"
        else
          message_from_chuck = JSON.parse(body)
          if message_from_chuck.length == 0
            msg.send "Achievement unlocked: Chuck Norris is quiet!"
          else
            msg.send message_from_chuck.value.joke
