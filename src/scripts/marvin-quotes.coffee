# Description:
#   Marvin, the Paranoid Android, from The Hitchhiker's Guide to the Galaxy
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot you saved me
#   hubot how is your life?
#
# Author:
#   jweslley

quotes = [
  "Life! Don't talk to me about life",
  "Life, loathe it or ignore it, you can't like it",
  "Life's bad enough as it is without wanting to invent any more of it",
  "Funny, how just when you think life can't possibly get any worse it suddenly does"
]

module.exports = (robot) ->

  robot.hear /you saved me/, (msg) ->
    msg.send "I know. Wretched isn't it?"

  robot.hear /(.*)(life)(.*)/i, (msg) ->
    msg.send msg.random quotes
