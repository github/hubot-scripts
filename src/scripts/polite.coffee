# Polite.
#
# Say thanks to your robot.

responses = [
  "You're welcome",
  "No problem",
  "Anytime",
  "That's what I'm here for!",
  "You are more than welcome",
  "You don't have to thank me, I'm your loyal servant",
  "Don't mention it."
]

module.exports = (robot) ->
  robot.respond /(thanks|thank you|cheers|nice one)/i, (msg) ->
    msg.send msg.random responses
