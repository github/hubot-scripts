# Description
#   When Hubot hears anyone say "What is this shit?" 
#   it responds with a relevant meme image 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   wtf is this shit - responds with a random WITS image
#   what the hell is this crap - responds with a random WITS image
#   what the fuck is that poop - responds with a random WITS image
#
# Author:
#   aaronbassett

witimgs = [
    "https://i.imgur.com/g5GET.jpg",
    "https://i.imgur.com/HSSmy.jpg",
    "https://i.imgur.com/wVIkb.jpg",
    "https://i.imgur.com/a6uNS.jpg",
    "https://i.imgur.com/QDEtx.jpg",
    "https://i.imgur.com/gED5u.jpg",
    "https://i.imgur.com/u6dvm.jpg",
    "https://i.imgur.com/TEtBW.jpg",
    "https://i.imgur.com/MMqJW.jpg",
    "https://i.imgur.com/4aa9h.jpg",
    "https://i.imgur.com/b3nmR.jpg"
]

module.exports = (robot) ->
  robot.hear /(what|wtf|what the fuck|wth|what the hell) is (this|that) (shit|crap|poop)/i, (msg) ->
    msg.send msg.random witimgs
