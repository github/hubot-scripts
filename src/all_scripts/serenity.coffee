# Description:
#   Serenity Now!!
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
#   madtimber

module.exports = (robot) ->
  robot.hear /serenity|serenity now/i, (msg) ->
    quotes = ["Serenity now...insanity later!",
              "Hey Braun!...Costanza is kicking your butt!",
              "Costanza, you're white hot!!",
              "Hey Braun, I got good news and bad news...and they're both the same, you're fired!",
              "Listen to me, George....I owe ya one.",
              "This is a place of business, I told you never to come in here! Serenity now!",
              "Hoochie mama!!!"]
    msg.send msg.random quotes
    msg.send "http://www.youtube.com/watch?v=dEMHtoWGLW0"
