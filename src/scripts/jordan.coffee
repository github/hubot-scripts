# Description:
#   Display a picture of Michael Jordan if anyone invokes "jordan" or says "23"
#   Cause Jordan is God. So much more than Steve Jobs :D
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   KuiKui

images = [
  "http://pictureloaders.com/images/pictures-of-michael-jordan18.jpg"
  "http://a7.idata.over-blog.com/0/54/95/85/Michael_Jordan1414.jpg"
  "http://02.img.v4.skyrock.net/028/michael-jordan-n23/pics/884566066_small.jpg"
  "http://absolutezone.files.wordpress.com/2008/11/michael_jordan014.jpg"
  "http://hrichert1.free.fr/IDD_BB_NT/postes_basket/Michael%20jordan.jpg"
  "http://www.michaeljordansworld.com/pictures/images/michael_jordan_dunks_jazz.jpg"
]

module.exports = (robot) ->
  robot.hear /(jordan|23)/i, (msg) ->
    msg.send msg.random images
