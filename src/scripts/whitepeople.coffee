# Description:
#   whitepeople 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   whitepeople - display a #whitepeople gif
#
# Author:
#   steven 

whitepeople = [
  "https://i.minus.com/iAkhq7VOddshd.gif",
  "http://farm9.staticflickr.com/8422/7711589464_ecb19d4e42_o.gif",
  "http://37.media.tumblr.com/26505168ab643fd58d1a07fa195e3812/tumblr_mrsae988OI1r03eaxo1_400.gif",
  "http://37.media.tumblr.com/2b767cc9b2a0870e4135cb01e07f3055/tumblr_n4xka1zglp1qdlh1io1_400.gif",
  "http://24.media.tumblr.com/ac955188d40c2cec67d351a027e9e733/tumblr_msj7pzXy8O1r03eaxo1_400.gif",
  "http://www.tuxboard.com/photos/2013/10/White-things-3.gif",
  "http://1.media.collegehumor.cvcdn.com/10/69/d3beb37da182fd766a452e792f6c649d-white-people-try-to-high-five.gif",
  "http://media.giphy.com/media/1V8ooLwgsUWHK/giphy.gif",
  "http://i3.kym-cdn.com/photos/images/newsfeed/000/694/687/631.gif",
  "http://media.giphy.com/media/ldoGBqBWEWK2s/giphy.gif",
  "http://media.giphy.com/media/hoJQdIXo9vZQs/giphy.gif",
  "http://media.giphy.com/media/fd1D74euLklLW/giphy.gif",
  "http://media.giphy.com/media/AvaHbrkoorQ08/giphy.gif",
  "http://media.giphy.com/media/SZMFvQg5u5ffa/giphy.gif",
  "http://i1.kym-cdn.com/photos/images/newsfeed/000/762/817/5df.gif",
  "http://media.giphy.com/media/6GpMJ0lYRMssU/giphy.gif",
  "http://media.giphy.com/media/1V3SdHyA4P57i/giphy.gif",
  "http://media.giphy.com/media/CqYmvxH8sj5XW/giphy.gif",
  "http://media.giphy.com/media/1J5ukcEA1izD2/giphy.gif",
  "http://media.giphy.com/media/eDgMpFc184yE8/giphy.gif",
  "http://media.giphy.com/media/NOQGYTXqGhn6o/giphy.gif",
  "http://i.imgur.com/YwXPvfB.gif",
  "http://i.imgur.com/1FCppEB.gif",
  "http://s3-ec.buzzfed.com/static/2014-05/enhanced/webdr05/23/11/anigif_enhanced-buzz-8354-1400857289-20.gif",
  "http://i.imgur.com/sBRav.gif",
  "http://i.imgur.com/Rnwsi49.gif",
  "http://i.imgur.com/4DJ6MCd.gif",
  "http://i.imgur.com/e7IVoaw.gif",
  "http://chimg.onionstatic.com/1607/animated/original.gif",
  "http://i.imgur.com/fVnav.gif",
  "http://i.imgur.com/aaB9tT0.gif",
  "http://i.imgur.com/wid8Lo2.gif"
]

module.exports = (robot) ->
  robot.hear /whitepeople/i, (msg) ->
    msg.send msg.random whitepeople
