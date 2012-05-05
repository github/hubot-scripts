# Carlton Celebration
#
# dance - Display a dancing Carlton
#

carltons = [
  "http://media.tumblr.com/tumblr_lrzrlymUZA1qbliwr.gif",
  "http://3deadmonkeys.com/gallery3/var/albums/random_stuff/Carlton-Dance-GIF.gif",
  "http://gifsoup.com/webroot/animatedgifs/987761_o.gif",
  "http://gifsoup.com/view1/1307943/carlton-banks-dance-o.gif",
  "http://s2.favim.com/orig/28/carlton-banks-dance-Favim.com-239179.gif",
  "http://gifsoup.com/webroot/animatedgifs/131815_o.gif"
]

module.exports = (robot) ->
  robot.hear /.*(dance|happy).*/i, (msg) ->
    msg.send msg.random carltons
