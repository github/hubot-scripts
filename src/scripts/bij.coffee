# EXPERIENCE BIJ
#

module.exports = (robot) ->
  robot.hear /bij/i, (msg) ->
    msg.send "EXPERIENCE BIJ!"
