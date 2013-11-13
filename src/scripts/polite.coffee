# Description:
#   Polite.
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
#   dannymcc

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
  input.match(new RegExp('\\b' + name + '\\b', 'i')) !== null

module.exports = (robot) ->
  robot.hear /\b(thanks|thank you|cheers|nice one)\b/i, (msg) ->
    msg.reply msg.random responses if youTalkinToMe(msg, robot)

  robot.hear /\b(ty|thx)\b/i, (msg) ->
    msg.reply msg.random shortResponses if youTalkinToMe(msg, robot)

  robot.hear /\b(hello|hi|sup|howdy|good (morning|evening|afternoon))\b/i, (msg) ->
    msg.reply "#{robot.name} at your service!" if youTalkinToMe(msg, robot)
    
  robot.hear /\b(bye|night|goodbye|good night)\b/i, (msg) ->
    msg.reply msg.random farewellResponses if youTalkinToMe(msg, robot)
