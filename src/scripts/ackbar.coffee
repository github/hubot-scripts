# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   it's a trap - Display an Admiral Ackbar piece of wonder
#
# Author:
#   brilliantfantastic

ackbars = [
  "http://dayofthejedi.com/wp-content/uploads/2011/03/171.jpg",
  "http://dayofthejedi.com/wp-content/uploads/2011/03/152.jpg",
  "http://farm4.static.flickr.com/3572/3637082894_e23313f6fb_o.jpg",
  "http://6.asset.soup.io/asset/0610/8774_242b_500.jpeg",
  "http://files.g4tv.com/ImageDb3/279875_S/steampunk-ackbar.jpg",
  "http://farm6.staticflickr.com/5126/5725607070_b80e61b4b3_z.jpg",
  "http://farm6.static.flickr.com/5291/5542027315_ba79daabfb.jpg",
  "http://farm5.staticflickr.com/4074/4751546688_5c76b0e308_z.jpg",
  "http://farm6.staticflickr.com/5250/5216539895_09f963f448_z.jpg",
  "http://static.fjcdn.com/pictures/Its_2031a3_426435.jpg",
  "http://www.millionaireplayboy.com/mpb/wp-content/uploads/2011/01/1293668358_bottom_trappy.jpeg",
  "http://allthingsackbar.com/wp-content/uploads/2010/02/bottom_ackbar_trap-500x446.gif",
  "http://31.media.tumblr.com/tumblr_lqrrkpAqjf1qiorsyo1_500.jpg",
  "https://i.chzbgr.com/maxW500/4930876416/hB0F640C6/",
  "http://i.qkme.me/356mr9.jpg",
  "http://24.media.tumblr.com/e4255aa10151ebddf57555dfa3fc8779/tumblr_mho9v9y5hE1r8gxxfo1_500.jpg",
  "http://farm2.staticflickr.com/1440/5170210261_fddb4c480c_z.jpg",
  "http://fashionablygeek.com/wp-content/uploads/2010/02/its-a-mouse-trap.jpg?cb5e28",
  "http://31.media.tumblr.com/tumblr_lmn8d1xFXN1qjs7yio1_500.jpg"
]

module.exports = (robot) ->
  robot.hear /it['’]?s a trap\b/i, (msg) ->
    msg.send msg.random ackbars
