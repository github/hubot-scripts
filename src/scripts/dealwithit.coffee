# Description:
#   Display a "deal with it" gif
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   deal with it - display a "deal with it" gif
#
# Author:
#   brianstanwyck

deal = [
  "https://i.imgur.com/ykDuU.gif",
  "https://i.imgur.com/3PWHn.gif",
  "https://i.imgur.com/sEinL.gif",
  "https://i.imgur.com/zsK7e.gif",
  "https://i.imgur.com/rE2aH.gif",
  "https://i.imgur.com/Wj3Do.gif",
  "https://i.imgur.com/SvdS0.gif",
  "https://i.imgur.com/bh6xc.gif",
  "https://i.imgur.com/aoaqO.gif",
  "https://i.imgur.com/oe01J.gif",
  "https://i.imgur.com/N5N4x.gif",
  "https://i.imgur.com/Z3KIP.gif",
  "https://i.imgur.com/oFo42.gif",
  "https://i.imgur.com/rbBAaRs.gif",
  "https://i.imgur.com/JDRZ21o.gif",
  "https://i.imgur.com/WhiQ67r.gif",
  "https://i.imgur.com/KLLX1xx.png",
  "https://i.imgur.com/BjtEpbY.gif",
  "https://i.imgur.com/Z3DJlxS.gif",
  "https://i.imgur.com/qjTTrcB.gif",
  "https://i.imgur.com/HHyy9RL.gif",
  "https://i.imgur.com/PilYVTI.gif",
  "https://i.imgur.com/i6xvVSN.gif",
  "https://i.imgur.com/5mnJ0je.gif",
  "https://i.imgur.com/myOz11I.gif",
  "https://i.imgur.com/VyKt1xD.gif",
  "https://i.imgur.com/tBGAWgf.gif",
  "https://i.imgur.com/2MTQrQf.gif",
  "https://i.imgur.com/CxhomG0.gif",
  "https://i.imgur.com/vA2UnyC.gif",
  "https://i.imgur.com/5pMiY03.gif"
]

module.exports = (robot) ->
  robot.hear /deal with it/i, (msg)->
    msg.send msg.random deal
