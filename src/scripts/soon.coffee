# Description:
#   Show a "SOON" image when someone says "soon"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   soon - Display a soon image (allows for many Os)
#
# Author:
#   keithamus

images = [
  "http://i.imgur.com/TVxNL84.png",
  "http://i.imgur.com/bFb5qZt.jpg",
  "http://i.imgur.com/qNiLQz3.png",
  "http://i.imgur.com/8niosvC.gif",
  "http://i.imgur.com/qX5jkRi.jpg",
  "http://i.imgur.com/Rqe94Xw.jpg",
  "http://i.imgur.com/i2leGDn.jpg",
  "http://i.imgur.com/QdnGKdY.jpg",
  "http://i.imgur.com/bkox94P.jpg",
  "http://i.imgur.com/hdG9IOk.jpg",
  "http://i.imgur.com/ne6T0UP.png",
  "http://i.imgur.com/41vZ1zP.png",
  "http://i.imgur.com/yweXMrA.jpg",
  "http://i.imgur.com/GcnzEjU.jpg",
  "http://i.imgur.com/J0PLa1k.jpg",
  "http://i.imgur.com/GHHLFqK.jpg",
  "http://i.imgur.com/o25zB5O.jpg",
  "http://i.imgur.com/6yyeCBR.jpg",
  "http://i.imgur.com/GKSdoAm.png",
  "http://i.imgur.com/3L0UQ8A.jpg",
  "http://i.imgur.com/7WhKHPh.gif",
  "http://i.imgur.com/xZuKr9v.gif",
  "http://i.imgur.com/GWSQBxx.jpg",
  "http://i.imgur.com/eCvTcTQ.jpg",
  "http://i.imgur.com/0ypfizN.jpg",
  "http://i.imgur.com/JyaroGd.jpg",
  "http://i.imgur.com/xUgmD93.jpg",
  "http://i.imgur.com/ftGheRE.jpg",
  "http://i.imgur.com/Y4ExtS5.gif",
  "http://i.imgur.com/pDXRVjp.jpg",
  "http://i.imgur.com/L2SZuzG.gif"
]

module.exports = (robot) ->
  robot.hear /\bso[o]+n\b/i, (msg) ->
    msg.send msg.random images
