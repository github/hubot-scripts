# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   where is bill? - Tell us where, where the hell Bill is.
#
# Author:
#   brandonvalentine

places = [
  "Well, maybe he went to get a sideways haircut",
  "Maybe he went to get a striped shirt",
  "Maybe he went to get some plastic shoes",
  "Maybe he went to get some funny sunglasses",
  "Well, maybe he went to get an Air Force parka",
  "Maybe he went to get a Vespa scooter",
  "Maybe he went to get a British flag",
  "Maybe he went to go Mod Ska dancing",
  "Well, maybe he went to get a mohawk",
  "And maybe he went to get some gnarly thrash boots",
  "Maybe he went to go ride his skateboard",
  "Maybe he went to see the Circle Jerks "
]

module.exports = (robot) ->
  robot.hear /where.*is.*bill/i, (msg) ->
    msg.send msg.random places
