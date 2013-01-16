# Description:
#   Quotes by Lawrence from Office Space
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hey lawrence - Display a random quote by Lawrence
#
# Notes:
#   None
#
# Author:
#   carmstrong

quotes = [
  "Fuckin' A, man!",
  "[from the next apartment through the wall] Don't worry, man. I won't tell anyone either.",
  "I'll tell you what I'd do, man: two chicks at the same time, man.",
  "Well, you don't need a million dollars to do nothing, man. Take a look at my cousin: he's broke, don't do shit.",
  "Peter... watch out for your cornhole, bud.",
  "No. No, man. Shit, no, man. I believe you'd get your ass kicked sayin' something like that, man.",
  "Hey Peter, man, check out channel 9, check out this chick."
]

module.exports = (robot) ->
  robot.hear /.*(hey lawrence).*/i, (msg) ->
    quote = msg.random quotes
    msg.send "http://movies.infinitecoolness.com/27/officespace18.jpg", "\"" + quote + "\""
