# Description:
#   Sends a sloth image URL
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   sloth me - Sends a sloth image URL
#
# Author:
#   NickPresta

sloths = [
  'https://i.imgur.com/p9HSmyR.jpg'
  'https://i.imgur.com/QLy8flr.jpg'
  'https://i.imgur.com/7asAJqw.jpg'
  'https://i.imgur.com/WHuyNUx.jpg'
  'https://i.imgur.com/stZo0zl.png'
  'https://i.imgur.com/bLJwgCN.jpg'
  'https://i.imgur.com/7MgspTH.jpg'
  'https://i.imgur.com/BqJpzvF.jpg'
  'https://i.imgur.com/txjUeA1.jpg'
  'https://i.imgur.com/cZ6GDFY.jpg'
  'https://i.imgur.com/6oZxYI9.jpg'
  'https://i.imgur.com/5OHdllr.jpg'
  'https://i.imgur.com/M7q1qzi.png'
  'https://i.imgur.com/FRrN5tX.jpg'
  'https://i.imgur.com/og36bRg.jpg'
  'https://i.imgur.com/uSg8rgi.png'
  'https://i.imgur.com/MXZ9mFr.jpg'
  'https://i.imgur.com/aztmlwT.jpg'
  'https://i.imgur.com/lIG1itA.png'
  'https://i.imgur.com/RRZyJYF.jpg'
  'https://i.imgur.com/VGxvMur.png'
  'https://i.imgur.com/egJKThb.jpg'
  'https://i.imgur.com/imABby8.jpg'
  'https://i.imgur.com/ySbRRiA.jpg'
  'https://i.imgur.com/HJ5ixut.jpg'
  'https://i.imgur.com/JoKTB9s.jpg'
  'https://i.imgur.com/tm5XmVS.jpg'
  'https://i.imgur.com/1iiahIU.jpg'
  'https://i.imgur.com/KiXxNhN.jpg'
  'https://i.imgur.com/QLXBeOX.jpg'
  'https://i.imgur.com/epfD9ps.png'
  'https://i.imgur.com/C975XnF.jpg'
  'https://i.imgur.com/7rz0Bll.jpg'
  'https://i.imgur.com/Mtl0pTt.jpg'
  'https://i.imgur.com/tBxfiOo.gif'
  'https://i.imgur.com/aiXPItB.gif'
  'https://i.imgur.com/WKIYCXY.gif'
  'https://i.imgur.com/PwOFcmM.gif'
  'https://i.imgur.com/gGgVGEn.gif'
  'https://i.imgur.com/NAJYZRJ.gif'
  'https://i.imgur.com/QppoTRe.gif'
  'https://i.imgur.com/DWoZS2y.gif'
  'https://i.imgur.com/eafrx63.gif'
]

module.exports = (robot) ->
  robot.hear /sloth me/i, (msg) ->
    msg.send msg.random sloths
