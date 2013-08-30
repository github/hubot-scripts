# Description:
#   When Steve Holt hears his name, Steve Holt makes his presence known
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   steve holt - Display an image of Steve Holt
#
# Author:
#   klamping

steves = [
  "http://www.ivygateblog.com/wp-content/uploads/2011/04/steve-holt.jpg",
  "http://blog.zap2it.com/frominsidethebox/arrested-development-will-arnett-justin-grant-wade-gob-steve-holt-season-3.jpg",
  "http://images2.fanpop.com/images/photos/3000000/Notapusy-steve-holt-3033209-1280-720.jpg",
  "http://images3.wikia.nocookie.net/__cb20121216182908/arresteddevelopment/images/c/c1/2x05_Sad_Sack_(17).png",
  "http://b68389.medialib.glogster.com/media/e3d4598233559b40af63f4b3ef93c66d57554b6b2c44e8ab094408d4af9c23bd/steve-holt-7.jpg",
  "http://i.imgur.com/mqDYUQV.png",
  "http://images1.wikia.nocookie.net/__cb20130601231816/arresteddevelopment/images/5/5d/4x07_Colony_Collapse_%28112%29.png",
  "http://images3.wikia.nocookie.net/__cb20130129170211/arresteddevelopment/images/thumb/5/5e/2x14_The_Immaculate_Election_%2877%29.png/200px-2x14_The_Immaculate_Election_%2877%29.png",
  "http://images1.wikia.nocookie.net/__cb20121216182908/arresteddevelopment/images/thumb/6/69/2x05_Sad_Sack_%2815%29.png/200px-2x05_Sad_Sack_%2815%29.png",
  "http://images2.wikia.nocookie.net/__cb20120123070042/arresteddevelopment/images/thumb/2/2b/1x03_Bringing_Up_Buster_%2811%29.png/200px-1x03_Bringing_Up_Buster_%2811%29.png"
]

module.exports = (robot) ->
  robot.hear /\b(steve holt)\b/i, (msg) ->
    msg.send msg.random steves