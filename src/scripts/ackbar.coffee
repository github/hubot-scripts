# It's a trap
#
# trap - Display an Admiral Ackbar piece of wonder
#

ackbars = [
  "http://dayofthejedi.com/wp-content/uploads/2011/03/171.jpg",
  "http://dayofthejedi.com/wp-content/uploads/2011/03/152.jpg",
  "http://farm4.static.flickr.com/3572/3637082894_e23313f6fb_o.jpg",
  "http://www.youtube.com/watch?v=dddAi8FF3F4",
  "http://6.asset.soup.io/asset/0610/8774_242b_500.jpeg",
  "http://files.g4tv.com/ImageDb3/279875_S/steampunk-ackbar.jpg",
  "http://farm6.staticflickr.com/5126/5725607070_b80e61b4b3_z.jpg",
  "http://www.x929.ca/shows/newsboy/wp-content/uploads/admiral-ackbar-mouse-trap.jpg",
  "http://farm6.static.flickr.com/5291/5542027315_ba79daabfb.jpg",
  "http://farm5.staticflickr.com/4074/4751546688_5c76b0e308_z.jpg",
  "http://farm6.staticflickr.com/5250/5216539895_09f963f448_z.jpg"
]

module.exports = (robot) ->
  robot.hear /.*(trap).*/i, (msg) ->
    msg.send msg.random ackbars