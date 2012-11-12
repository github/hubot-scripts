# Description:
#   Decides where your team should get their grub on
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   grub add - Add a grubbery to the list
#   grub rm - Remove a grubbery from the list
#   grub ls - List all of the grubberies that have been added
#   grub time - Chooses a grubbery at random
#
# Notes:
#   None
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.grub ||= []

  robot.hear /grub add (.*)/i, (msg) ->
    grubhub = msg.match[1]
    if grubhub.length
      robot.brain.data.grub.push(grubhub)
    else
      msg.send "Provide a grubbery..."

  robot.hear /grub rm (.*)/i, (msg) ->
    grubhub = msg.match[1]
    if grubhub.length
      robot.brain.data.grub = robot.brain.data.grub.filter (x) -> x != grubhub
    else
      msg.send "Provide a grubbery..."

  robot.hear /grub ls/i, (msg) ->
    msg.send "Grubberies: #{ robot.brain.data.grub.join(", ") }"

  robot.hear /grub time/i, (msg) ->
    msg.send "We're grubbing at #{ msg.random robot.brain.data.grub } today"
