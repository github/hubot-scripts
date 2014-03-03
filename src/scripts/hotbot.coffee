# Description:
#   Allows a group of users to randomly decide who makes tea and coffee.
#
# Dependencies:
#   "hubot-slack": "2.0.3"
#
# Configuration:
#   HEROKU_URL
#   HUBOT_SLACK_TOKEN
#   HUBOT_SLACK_TEAM
#   HUBOT_SLACK_BOTNAME
#
# Commands:
#   i want <tea/coffee> - Adds an order to the pile.
#
# Notes:
#   Once five orders have been entered, Hotbot decides who shall make the drinks.
#   Emoji is supported - try :tea: and :coffee:!
#   Deploy the bot to Heroku.
#
# Author:
#   calumgunn

maxVotes = 5
participants = []
resetTimer = null

fiveDrinks = (msg) ->
  winner = participants[Math.floor(Math.random() * participants.length)]
  msg.send "HOT DRINKS TIME! The winner is: #{winner}! Good luck out there."
  clearTimeout(resetTimer)
  participants = []
  return

module.exports = (robot) ->
  robot.hear /i want :?(tea|coffee):?/i, (msg) ->
    drink = msg.match[1]
    participants.push(msg.message.user.name)
    if participants.length is maxVotes
      fiveDrinks msg
    else
      clearTimeout(resetTimer)
      resetTimer = setTimeout () ->
        msg.send "TOO BAD! Not enough votes. Stay strong though! RESETTING VOTES..."
        participants = []
      , 600000
      msg.send "One vote for #{drink} from #{msg.message.user.name} - that makes #{participants.length}..."

