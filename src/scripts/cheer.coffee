# Feeling depressed?
#
# cheer me up - A little pick me up
module.exports = (robot) ->
  robot.respond /cheer me up/i, (msg) ->
    aww msg

  robot.hear /i( am|'m) emo/i, (msg) ->
    msg.send "Let me cheer you up."
    aww msg

aww = (msg) ->
  msg
    .http('http://imgur.com/r/aww.json')
      .get() (err, res, body) ->
        images = JSON.parse(body)
        images = images.gallery
        image  = msg.random images
        msg.send "http://i.imgur.com/#{image.hash}#{image.ext}"
