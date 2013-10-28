# Description:
#   Loads up Celery Man
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   danryan

tayne = false
moretayne = false

module.exports = (robot) ->
  robot.respond /.*celery\s?man/i, (msg) ->
    msg.send "http://mlkshk.com/r/4SBP.gif"
  robot.respond /.*4d3d3d3/i, (msg) ->
    msg.send "4d3d3d3 ENGAGED"
    msg.send "http://i.imgur.com/w1qQO.gif"
  robot.respond /.*add sequence:? oyster/i, (msg) ->
    msg.send "http://i.imgur.com/EH2CJ.png"
  robot.respond /.*oyster smiling/, (msg) ->
    # msg.send "http://i.imgur.com/e71P6.png"
    msg.send "http://i.imgur.com/eq5v0RY.gif"
  robot.respond /do we have any new sequences/i, (msg) ->
    tayne = true
    moretayne = true
    msg.send "I have a BETA sequence I have been working on."
    msg.send "Would you like to see it?"
    setTimeout (-> moretayne = false), 10000
    setTimeout (-> tayne = false), 10000
  robot.respond /.*hat wobble/i, (msg) ->
    msg.send "http://i.imgur.com/5kVq4.gif"
  robot.respond /.*flarhgunnstow/i, (msg) ->
    msg.send "http://i.imgur.com/X0sNq.gif"
  robot.respond /.*nude tayne/, (msg) ->
    msg.send "Not computing. Please repeat:"
  robot.respond /NUDE TAYNE/, (msg) ->
    msg.send "http://i.imgur.com/yzLcf.png"
  robot.hear /yes/i, (msg) ->
    if tayne and moretayne
      moretayne = false
      msg.send "http://imgur.com/h27BPKW"
  robot.hear /tayne/gi, (msg) ->
    if tayne and not moretayne
      tayne = false
      msg.send "http://imgur.com/TrdLwoz"
