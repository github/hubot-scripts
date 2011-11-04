# Happiness in image form
#
# me gusta - Display "Me Gusta" face when heard
#
module.exports = (robot) ->
  robot.hear /me gusta/i, (msg) ->
    msg.send "http://s3.amazonaws.com/kym-assets/entries/icons/original/000/002/252/me-gusta.jpg"