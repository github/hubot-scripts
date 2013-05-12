# Description:
#   When in doubt, blame Obama
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   thanks obama - Display a random "thanks obama" gif
#
# Author:
#   alexgandy

obamas = [
  "http://i.imgur.com/e1NISpo.gif",
  "http://media.tumblr.com/fa20c7c12406e8bb9741c550c77e1a54/tumblr_inline_mi8bu9UC5i1qz4rgp.gif",
  "http://media.tumblr.com/ae6ffd132fb0cbd2e17073bcba96e58f/tumblr_inline_mi8btlwrMx1qz4rgp.gif",
  "http://i.imgur.com/TpUE29w.gif",
  "http://i.imgur.com/qtj82FT.gif",
  "http://i.imgur.com/6iW1MOa.gif",
  "http://i.imgur.com/1IZH7up.gif",
  "http://i.imgur.com/IXAcRGw.gif",
  "http://i.imgur.com/qxTvxyC.gif",
  "http://i.imgur.com/hFy4MLM.gif",
  "http://i.imgur.com/CRNdVnP.gif",
  "http://i.imgur.com/xdob6xa.gif",
  "http://i.imgur.com/Cx7Ws.gif",
  "http://i.imgur.com/7TmgI.gif",
  "http://i.imgur.com/qpJa6.gif",
  "http://i.imgur.com/S0D9w.gif",
  "http://i.imgur.com/KK9lE.gif",
  "http://i.imgur.com/tTGjX.gif",
  "http://i.imgur.com/6R8r0.gif",
  "http://i.imgur.com/fmkD0.gif"
]

module.exports = (robot) ->
  robot.hear /thanks obama/i, (msg) ->
    msg.send msg.random obamas
