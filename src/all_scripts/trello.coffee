# Description:
#   Create new cards in Trello
#
# Dependencies:
#   "node-trello": "latest"
#
# Configuration:
#   HUBOT_TRELLO_KEY - Trello application key
#   HUBOT_TRELLO_TOKEN - Trello API token
#   HUBOT_TRELLO_LIST - The list ID that you'd like to create cards for
#
# Commands:
#   hubot trello card <name> - Create a new Trello card
#
# Notes:
#   To get your key, go to: https://trello.com/1/appKey/generate
#   To get your token, go to: https://trello.com/1/authorize?key=<<your key>>&name=Hubot+Trello&expiration=never&response_type=token&scope=read,write
#   To get your list ID, go to: https://trello.com/1/members/my/cards?key=<<your key>>&token=<<your token>> and find a card on the list you'd like to use. The ID is the idList attribute
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.respond /trello card (.*)/i, (msg) ->
    cardName = msg.match[1]
    if not cardName.length
      msg.send "You must give the card a name"
      return
    if not process.env.HUBOT_TRELLO_KEY
      msg.send "Error: Trello app key is not specified"
    if not process.env.HUBOT_TRELLO_TOKEN
      msg.send "Error: Trello token is not specified"
    if not process.env.HUBOT_TRELLO_LIST
      msg.send "Error: Trello list ID is not specified"
    if not (process.env.HUBOT_TRELLO_KEY and process.env.HUBOT_TRELLO_TOKEN and process.env.HUBOT_TRELLO_LIST)
      return
    createCard msg, cardName

createCard = (msg, cardName) ->
  Trello = require("node-trello")
  t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
  t.post "/1/cards", {name: cardName, idList: process.env.HUBOT_TRELLO_LIST}, (err, data) ->
    if err
      msg.send "There was an error creating the card"
      return
    msg.send data.url
