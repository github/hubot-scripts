# Description:
#   GOOD Night
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   good night
#
# Author:
#   noahhendrix

ways_to_say_good_night = [
  "Good night, baby.",
  "Night hot stuff.",
  "Like I'm going to let you get any sleep",
  "LOOK...the moon is calling you, SEE...the stars are shining for you, HEAR... my heart saying good night.",
  "Sleep tight, don't let the bed bugs bite",
  "May you never urinate the sweet sweet sounds of 70's disco funk",
  "So long, and thanks for all the fish.",
  "Finally",
  "À voir!",
  "Don't let the back door hit ya where the good Lord split ya",
  "May your feet never fall off and grow back as cactuses",
  "TTYL",
  "C U L8R",
  "Fine, then go!",
  "Cheers",
  "Uh, I can hear the voices calling me...see ya",
  "In a while, crocodile",
  "SHOO! SHOO!",
  "No more of you.",
  "Avada Kedavra"
]

module.exports = (robot) ->
  robot.hear /(good night|bye|nighty night)/i, (msg) ->
    msg.send msg.random ways_to_say_good_night
