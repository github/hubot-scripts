# Description:
#   Control a nodecopter via chat
#
# Dependencies:
#   "ar-drone":"0.2.0"
#   "imgur-node-api":"0.0.2"
#
# Configuration:
#   HUBOT_IMGUR_API_KEY
#
# Commands:
#   hubot takeoff
#   hubot land
#   hubot forward
#   hubot back
#   hubot left
#   hubot right
#   hubot up
#   hubot down
#   hubot photo
#   hubot clockwise
#   hubot anticlockwise
#   hubot stop
#   hubot photo
#   hubot status
#
# Author:
#   andrew

arDrone = require("ar-drone")
imgur = require('imgur-node-api')
path = require('path')
fs = require('fs')

imgur.setClientID(process.env.HUBOT_IMGUR_API_KEY);
client = arDrone.createClient()

module.exports = (robot) ->
  robot.respond /takeoff/i, (msg) ->
    msg.send 'Roger that!'
    client.takeoff ->
      msg.send 'In the air'

  robot.respond /land/i, (msg) ->
    msg.send 'Bringing her home'
    client.land ->
      msg.send 'I give that landing a 9 . . . on the Richtor scale.'

  robot.respond /forward/i, (msg) ->
    client.front(0.1)
    msg.send 'Moving Forward'

  robot.respond /back/i, (msg) ->
    client.back(0.1)
    msg.send 'Moving back'

  robot.respond /up/i, (msg) ->
    client.up(0.2)
    msg.send 'Moving up'
    
  robot.respond /down/i, (msg) ->
    client.down(0.2)
    msg.send 'Moving down'

  robot.respond /left/i, (msg) ->
    client.left(0.1)
    msg.send 'Moving left'

  robot.respond /right/i, (msg) ->
    client.right(0.1)
    msg.send 'Moving right'

  robot.respond /clockwise/i, (msg) ->
    client.clockwise(0.1)
    msg.send 'Turning clockwise'

  robot.respond /anticlockwise/i, (msg) ->
    client.clockwise(-0.1)
    msg.send 'Turning anticlockwise'

  robot.respond /flip/i, (msg) ->
    client.animate('flipLeft', 500)
    msg.send "Flipping heck that's a bit of a bugger"

  robot.respond /stop/i, (msg) ->
    client.stop()
    msg.send 'Hammertime'

  robot.respond /status/i, (msg) ->
    client.once 'navdata', (data) ->
      msg.send "Battery: #{data.demo.batteryPercentage}%"

  robot.respond /photo|picutre/i, (msg) ->
    client.getPngStream().once 'data', (data) ->
      fs.writeFile 'photo.jpg', data, ->
        imgur.upload path.join(__dirname, "../photo.jpg"), (err, res) ->
          msg.send res.data.link