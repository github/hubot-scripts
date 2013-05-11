# Description:
#   Homer Simpson quotes.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   beer - replies with random beer quote
#   <food> - replies with "Mmmm... <food>"
#   internet - replies with random internet quote
#   try - replies with random try quote
#
# Author:
#   bhankus

beerQuotes = [
  "Beer... Now there's a temporary solution.",
  "All right, brain. You don't like me and I don't like you, but let's just do this and I can get back to killing you with beer.",
  "Mmmm... beer",
  "Beer: The cause of, and solution to, all of life's problems.",
  "Beer, beer, beer, bed, bed, bed.",
  "I would kill everyone in this room for a drop of sweet beer."
]

tryQuotes = [
  "Kids, you tried your best and you failed miserably. The lesson is, never try.",
  "Trying is the first step towards failure."
]

internetQuotes = [
  "Oh, so they have internet on computers now!",
  "The Internet? Is that thing still around?"
]

module.exports = (robot) ->
  robot.hear /beer/i, (msg) ->
    msg.send msg.random beerQuotes
  robot.hear /bacon|bagel|barbecue|burger|candy|chocolate|donut|sandwich|breakfast|lunch|dinner|food|grub/i, (msg) ->
    msg.send "Mmmm... " + msg.match[0]
  robot.hear /try/i, (msg) ->
    msg.send msg.random tryQuotes
  robot.hear /internet/i, (msg) ->  
    msg.send msg.random internetQuotes