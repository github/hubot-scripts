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

# http://en.wikipedia.org/wiki/You_talkin'_to_me%3F
youTalkinToMe = (msg, robot) ->
  input = msg.message.text.toLowerCase()
  name = robot.name.toLowerCase()
  input.indexOf(name) != -1

module.exports = (robot) ->
  robot.respond /(thanks|thank you|cheers|nice one)/i, (msg) ->
    msg.reply msg.random responses if youTalkinToMe(msg, robot)

  robot.respond /(ty|thx)/i, (msg) ->
    msg.reply msg.random shortResponses if youTalkinToMe(msg, robot)

  robot.respond /(hello|hi|sup|howdy|good (morning|evening|afternoon))/i, (msg) ->
    msg.reply "#{robot.name} at your service!" if youTalkinToMe(msg, robot)
    
  robot.respond /(bye|night|goodbye|good night)/i, (msg) ->
    msg.reply msg.random farewellResponses if youTalkinToMe(msg, robot)
