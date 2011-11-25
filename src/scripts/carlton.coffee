# Carlton Celebration
#
# dance - Display a dancing Carlton
#

carltons = [
  "http://media.tumblr.com/tumblr_lrzrlymUZA1qbliwr.gif",
  "http://3deadmonkeys.com/gallery3/var/albums/random_stuff/Carlton-Dance-GIF.gif"
]

module.exports = (robot) ->
  robot.hear /.*(dance|happy).*/i, (msg) ->
    msg.send msg.random carltons
