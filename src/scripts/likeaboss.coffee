# Description:
#   LIKE A BOSS
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
#   jrgifford

images = [
  "http://s3.amazonaws.com/kym-assets/photos/images/original/000/114/151/14185212UtNF3Va6.gif?1302832919",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/110/885/boss.jpg",
  "http://assets.head-fi.org/b/b3/b3ba6b88_funny-facebook-fails-like-a-boss3.jpg",
  "http://img.anongallery.org/img/6/0/like-a-boss.jpg",
  "http://www.demotivers.com/uploads/2011_02/02/7733_1292_500_Like-A-Boss.jpg",
  "http://images.cheezburger.com/completestore/2011/2/20/a4ea536d-4b21-4517-b498-a3491437d224.jpg",
  "http://funcorner.eu/wp-content/uploads/2011/03/like_a_boss.jpg",
  "https://i.chzbgr.com/maxW500/6972126976/hAA5A99AF/",
  "https://i.chzbgr.com/maxW500/6669391104/h7509954E/",
  "https://i.imgur.com/eNXkb.gif",
  "https://i.imgur.com/WN8Ud.gif",
  "https://i.imgur.com/9y0VV.gif",
  "https://i.imgur.com/68Jtv.gif",
  "https://i.imgur.com/hdVDd.gif",
  "https://i.imgur.com/B0ehW.gif",
  "https://i.imgur.com/3GU2Q.gif",
  "https://i.imgur.com/Z3aAs.gif",
  "https://i.imgur.com/diA9N.gif",
  "https://i.imgur.com/ze3MJ.gif",
  "https://i.imgur.com/rBvJany.gif"
  ]

module.exports = (robot) ->
  robot.hear /like a boss|boss|like a baws|baws/i, (msg) ->
    msg.send msg.random images
