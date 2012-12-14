# Description:
#   Load a random Grumpy Cat from an array of images.
#   Based on pugme.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot grumpycat me - Receive a Grumpy Cat
#   hubot grumpycat bomb N - get N Grumpy Cats
#
# Author:
#   trey

cats = [
  "http://mlkshk.com/r/M6EO.gif", # rabbit in a hat
  "http://mlkshk.com/r/M17S.gif", # dress
  "http://mlkshk.com/r/M15O.gif", # le mis
  "http://mlkshk.com/r/M01A.gif", # cartoons
  "http://mlkshk.com/r/LZ7U.gif", # fuck this
  "http://mlkshk.com/r/LXP2.gif", # grumpy tardar sauce
  "http://mlkshk.com/r/LWNG.gif", # grandma got run over
  "http://mlkshk.com/r/LVVR.gif", # double deal with it
  "http://mlkshk.com/r/LV0S.gif", # mural
  "http://mlkshk.com/r/LUYE.gif", # stahp
  "http://mlkshk.com/r/LUO2.gif", # good
  "http://mlkshk.com/r/LS6R.gif", # shut the fuck up
  "http://mlkshk.com/r/LSWD.gif", # Tardar Bonepart
  "http://mlkshk.com/r/LPCN.gif", # drawing
  "http://mlkshk.com/r/LLVD.gif", # terrible time of the year
  "http://mlkshk.com/r/LKTG.gif", # Citizen Kane
  "http://mlkshk.com/r/LEF8.gif", # emotions
  "http://mlkshk.com/r/LEFR.gif", # skate deck
  "http://mlkshk.com/r/L337.gif", # look askance
  "http://mlkshk.com/r/KV8K.gif", # sitting
  "http://mlkshk.com/r/KU1S.gif", # 3 grump moon
  "http://mlkshk.com/r/KRBA.gif", # rabbit painting
  "http://mlkshk.com/r/KL19.gif"  # lying on the ground
]

module.exports = (robot) ->
  robot.respond /grumpycat me/i, (msg) ->
    msg.send cats[Math.floor(Math.random()*cats.length)]

  robot.respond /grumpycat bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    for i in [1..count] by 1
      msg.send cats[Math.floor(Math.random()*cats.length)]

  robot.respond /how many grumpycats are there/i, (msg) ->
    msg.send "There are #{cats.length} grumpycats."
