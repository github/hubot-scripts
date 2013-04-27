# Description:
#   Homer Simpson quotes.
#
# Dependencies:
#   None
#
# Configuration:
#   robotUsername = your robot's name to ignore hearing messages from it
#
# Commands:
#   beer - replies with random beer quote
#   <food> - replies with "Mmmm... <food>"
#   internet - replies with random internet quote
#   try - replies with random try quote
#
# Author:
#   bhankus
robotUsername = 'YOUR_ROBOTS_USERNAME'

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

notRobot = (user) ->
  if user isnt robotUsername then true else false

module.exports = (robot) ->
  robot.hear /beer/i, (msg) ->
    if notRobot(msg.message.user.name)
      msg.send msg.random beerQuotes

  robot.hear /bacon|bagel|barbecue|burger|candy|chocolate|donut|sandwich|breakfast|lunch|dinner|food|grub/i, (msg) ->
    if notRobot(msg.message.user.name)
      msg.send "Mmmm... " + msg.match[0]

  robot.hear /try/i, (msg) ->
    if notRobot(msg.message.user.name)
      msg.send msg.random tryQuotes

  robot.hear /internet/i, (msg) ->  
    if notRobot(msg.message.user.name)
      msg.send msg.random internetQuotes
