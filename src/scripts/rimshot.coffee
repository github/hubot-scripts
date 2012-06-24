# Description:
#   Emphasize a joke
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   rimshot - Link to a short video of a rimshot
#
# Author:
#   mrtazz

shots = [
    'http://www.youtube.com/watch?v=DH5p5iMEbrE',
    'http://www.youtube.com/watch?v=6zXDo4dL7SU',
    'http://www.youtube.com/watch?v=GnOl4VcV5ng',
    'http://www.youtube.com/watch?v=3gPV2wzNNyo'
]

module.exports = (robot) ->
  robot.hear /rimshot/i, (msg) ->
    msg.send msg.random shots
