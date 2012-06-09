# Description:
#   Integrates with join.me 
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JOINME_AUTHCODE
#
# Commands:
#   hubot joinme - Generates a new join.me 9-digit code and outputs a presenter link (download) and a participant link (to view the session)
#
# Author:
#   webandtech

module.exports = (robot) ->
  robot.respond /joinme$/i, (msg) ->
    joinme(msg)

joinme = (msg) ->
  authCode = process.env.HUBOT_JOINME_AUTHCODE

  unless authCode?
    msg.send "Join.me account isn't setup. Use https://secure.join.me/API/requestAuthCode.aspx?email=EMAIL&password=PASSWORD to get your authCode."
    msg.send "Then ensure the HUBOT_JOINME_AUTHCODE environment variable is set"
    return

  msg.http('https://secure.join.me/API/requestCode.aspx')
    .query
      authcode: authCode,
    .get() (err, res, body) ->

      
     if body.indexOf "OK" isnt "-1"
       split = body.split(":")
       ticket = split[2].replace(/^\s+|\s+$/g,"").replace("#chr(13)#|#chr(9)#|\n|\r", "")
       code = split[1].split("TICKET")[0].replace(/^\s+|\s+$/g,"").replace("#chr(13)#|#chr(9)#|\n|\r", "")
       presenter = "Presenter: https://secure.join.me/download.aspx?code="+code+"&ticket="+ticket
       viewer = "Viewer: http://join.me/"+code
       msg.send presenter
       msg.send viewer
     else
       msg.send "ERROR join.me #epicfail!"
