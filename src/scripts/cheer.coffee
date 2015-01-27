# Description:
#   Feeling depressed?
#
# Dependencies:
#   None
#
# Configuration:
#   Store your imgur.com application client id in an environment
#   variable called IMGUR_CLIENT_ID. To get API access, visit
#   http://api.imgur.com and register an application.
#
# Commands:
#   hubot cheer me up - A little pick me up
#
# Author:
#   carllerche

module.exports = (robot) ->
  robot.respond /cheer me up/i, (msg) ->
    aww msg

  robot.hear /i( am|'m) emo/i, (msg) ->
    msg.send "Let me cheer you up."
    aww msg

aww = (msg) ->
  client_id = 'Client-ID ' + process.env.IMGUR_CLIENT_ID
  msg
    .http('https://api.imgur.com/3/gallery/r/aww')
      .headers(Authorization: client_id)
      .get() (err, res, body) ->
        images = JSON.parse(body)
        images = images.data
        image  = msg.random images
        msg.send image.link
