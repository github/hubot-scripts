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
  'http://i.imgur.com/p9HSmyR.jpg'
  'http://i.imgur.com/QLy8flr.jpg'
  'http://i.imgur.com/7asAJqw.jpg'
  'http://i.imgur.com/WHuyNUx.jpg'
  'http://i.imgur.com/stZo0zl.png'
  'http://i.imgur.com/bLJwgCN.jpg'
  'http://i.imgur.com/7MgspTH.jpg'
  'http://i.imgur.com/BqJpzvF.jpg'
  'http://i.imgur.com/txjUeA1.jpg'
  'http://i.imgur.com/cZ6GDFY.jpg'
  'http://i.imgur.com/6oZxYI9.jpg'
  'http://i.imgur.com/5OHdllr.jpg'
  'http://i.imgur.com/M7q1qzi.png'
  'http://i.imgur.com/FRrN5tX.jpg'
  'http://i.imgur.com/og36bRg.jpg'
  'http://i.imgur.com/uSg8rgi.png'
  'http://i.imgur.com/MXZ9mFr.jpg'
  'http://i.imgur.com/aztmlwT.jpg'
  'http://i.imgur.com/lIG1itA.png'
  'http://i.imgur.com/RRZyJYF.jpg'
  'http://i.imgur.com/VGxvMur.png'
  'http://i.imgur.com/egJKThb.jpg'
  'http://i.imgur.com/imABby8.jpg'
  'http://i.imgur.com/ySbRRiA.jpg'
  'http://i.imgur.com/HJ5ixut.jpg'
  'http://i.imgur.com/JoKTB9s.jpg'
  'http://i.imgur.com/tm5XmVS.jpg'
  'http://i.imgur.com/1iiahIU.jpg'
  'http://i.imgur.com/KiXxNhN.jpg'
  'http://i.imgur.com/QLXBeOX.jpg'
  'http://i.imgur.com/epfD9ps.png'
  'http://i.imgur.com/C975XnF.jpg'
  'http://i.imgur.com/7rz0Bll.jpg'
  'http://i.imgur.com/Mtl0pTt.jpg'
]

module.exports = (robot) ->
  robot.hear /sloth me/i, (msg) ->
    msg.send msg.random sloths
