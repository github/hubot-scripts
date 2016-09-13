# Description:
#   Motivation from Ron Swanson
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot swanson me - Motivates you to be more awesome
#
# Author:
#   danielmurphy

module.exports = (robot) ->
  robot.respond /swanson me$/i, (msg) ->
    images = [
      "https://i.imgur.com/kW0f7.jpg",
      "https://i.imgur.com/vw9gZ.jpg",
      "https://i.imgur.com/aV6ju.jpg",
      "https://i.imgur.com/AQBJW.jpg",
      "https://i.imgur.com/tKkRO.png",
      "https://i.imgur.com/lkbGP.png",
      "https://i.imgur.com/mx54e.jpg",
      "https://i.imgur.com/LASrK.jpg",
      "https://i.imgur.com/zvUBG.jpg",
      "https://i.imgur.com/tjqca.jpg",
      "https://i.imgur.com/q5CYv.jpg",
      "https://i.imgur.com/HsoXm.jpg",
      "https://i.imgur.com/6EGQm.jpg",
      "https://i.imgur.com/DxpKu.jpg",
      "https://i.imgur.com/h2c7L.jpg",
      "https://i.imgur.com/jNyXL.jpg",
      "https://i.imgur.com/K09cJ.jpg",
      "https://i.imgur.com/mO0UE.jpg",
      "https://i.imgur.com/9hhkx.jpg"]
    msg.send msg.random images
