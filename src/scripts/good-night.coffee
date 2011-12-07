# GOOD Night
#
# good night

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

# Make sure that hubot says good night
#
# good night - Make sure hubot replies
module.exports = (robot) ->
  robot.respond /(good night|bye|nighty night)/i, (msg) ->
    randomNumber = Math.ceil Math.random() * ways_to_say_good_night.length
    msg.send ways_to_say_good_night[randomNumber]

