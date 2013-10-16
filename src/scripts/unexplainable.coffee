# Description:
#   When hubot hears someone say unexplainable, it does its best to show a visual aid.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   unexplainable - Display a picture of something unexplainable
#
# Author:
#   pjaspers

wtfs = ["http://i.imgur.com/On3fuEZ.jpg",
"http://i.imgur.com/iS29j8G.jpg",
"http://i.imgur.com/sS0a1Kw.jpg",
"http://i.imgur.com/yOQyjdR.jpg",
"http://i.imgur.com/gky7VZp.jpg",
"http://i.imgur.com/Oj7YTsw.jpg",
"http://i.imgur.com/Oy77uAH.jpg",
"http://i.imgur.com/zjsmNiE.jpg",
"http://i.imgur.com/i9mBrul.jpg",
"http://i.imgur.com/8hq2Onc.jpg",
"http://i.imgur.com/olFFC3j.jpg",
"http://i.imgur.com/AZOil4I.jpg",
"http://i.imgur.com/HdanSqZ.jpg",
"http://i.imgur.com/f1sZsTv.jpg",
"http://i.imgur.com/7GCBTL2.jpg",
"http://i.imgur.com/4QJr32t.jpg",
"http://i.imgur.com/Qq44l9t.jpg",
"http://i.imgur.com/KXxa6Lo.jpg",
"http://i.imgur.com/TrX5eec.jpg",
"http://i.imgur.com/64Hivci.jpg",
"http://i.imgur.com/ghFW159.jpg",
"http://i.imgur.com/JdCFVNA.jpg",
"http://i.imgur.com/da4hoa9.jpg",
"http://i.imgur.com/XYb5LOD.jpg",
"http://i.imgur.com/3RS4pnt.jpg",
"http://i.imgur.com/EzSdXCt.jpg",
"http://i.imgur.com/v9P3XJ7.jpg",
"http://i.imgur.com/MwemoCX.jpg",
"http://i.imgur.com/1XGoFPH.jpg",
"http://i.imgur.com/W0p4CFH.jpg",
"http://i.imgur.com/gOcVrq8.jpg",
"http://i.imgur.com/bsEcRjn.jpg",
"http://i.imgur.com/3x8PUXp.jpg",
"http://i.imgur.com/LHdnD3L.jpg",
"http://i.imgur.com/BOa7ZKy.jpg",
"http://i.imgur.com/N8ojcdY.jpg",
"http://i.imgur.com/HKbi3G1.jpg",
"http://i.imgur.com/VEmrUp6.jpg"]

module.exports = (robot) ->
  robot.hear /unexplainable/i, (msg) ->
    msg.send msg.random wtfs
