# Description:
#   Generate random user data from randomuser.me
#
# Dependencies:
#   None
#
# Commands:
#   hubot random user - Get random user data from randomuser.me
#
# Author:
#   tombell

String::capitalize = ->
  "#{@charAt(0).toUpperCase()}#{@slice(1)}"

module.exports = (robot) ->

  robot.respond /(random|generate) user/i, (msg) ->
    msg.http('http://randomuser.me/g/')
      .get() (err, res, body) ->
        if err?
          msg.reply "Error occured generating a random user: #{err}"
        else
          try
            data = JSON.parse(body).results[0].user
            msg.send "#{data.name.first.capitalize()} #{data.name.last.capitalize()}\n" +
              "Gender: #{data.gender}\n" +
              "Email: #{data.email}\n" +
              "Picture: #{data.picture}"

          catch err
            msg.reply "Error occured parsing response body: #{err}"
