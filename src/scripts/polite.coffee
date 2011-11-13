# Polite.
#
# Say thanks to your robot.

responses = [
  "You're welcome.",
  "No problem.",
  "Anytime.",
  "That's what I'm here for!",
  "You are more than welcome.",
  "You don't have to thank me, I'm your loyal servant.",
  "Don't mention it."
]

shortResponses = [
  'vw',
  'np',
]

farewellResponses = [
  'Goodbye',
  'Have a good evening',
  'Bye',
  'Take care',
  'Nice speaking with you',
  'See you later'
]

module.exports = (robot) ->
  robot.respond /(thanks|thank you|cheers|nice one)/i, (msg) ->
    msg.reply msg.random responses

  robot.respond /(ty|thx)/i, (msg) ->
    msg.reply msg.random shortResponses

  robot.respond /(hello|hi|sup|howdy|good (morning|evening|afternoon))/i, (msg) ->
    msg.reply "#{robot.name} at your service!"
    
  robot.respond /(bye|night|goodbye|good night)/i, (msg) ->
    msg.reply msg.random farewellResponses
