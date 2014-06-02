# Description:
#   Returns gif from Jeff Larson's http://ihatemy.computer/_/
#
# Dependencies:
#   Underscore
#
# Commands
#   i hate my computer || ihmc returns a random gif
#   hubot ____ returns a specific ihmc gif
#
# Author:
#   Gerald Rich @geraldarthur

_ = require("underscore")

images =
  debugging: "http://ihatemy.computer/_/debugging.gif"
  icanteven: "http://ihatemy.computer/_/icanteven.jpg"
  lol_dns: "http://ihatemy.computer/_/lol-dns.png"
  marky_mark: "http://ihatemy.computer/_/marky-mark.gif"
  pancakes: "http://ihatemy.computer/_/pancakes.png"
  panda: "http://ihatemy.computer/_/panda.gif"
  spinner: "http://ihatemy.computer/_/spinner.gif"
  swanson: "http://ihatemy.computer/_/swanson.gif"

module.exports = (robot) ->
	robot.hear /(i hate my computer|ihmc)/i, (msg) ->
		msg.send msg.random _.values(images)

  robot.respond /(debugging)/i, (msg) ->
    msg.send images.debugging

  robot.respond /(i cant even|i can\'t even)/i, (msg) ->
    msg.send images.icanteven

  robot.respond /(lol dns)/i, (msg) ->
    msg.send images.lol_dns

  robot.respond /(marky mark)/i, (msg) ->
    msg.send images.marky_mark

  robot.respond /(pancakes)/i, (msg) ->
    msg.send images.pancakes

  robot.respond /(panda)/i, (msg) ->
    msg.send images.panda

  robot.respond /(spinner)/i, (msg) ->
    msg.send images.spinner

  robot.respond /(swanson)/i, (msg) ->
    msg.send images.swanson