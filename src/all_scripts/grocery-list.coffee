# Description:
#   Organize your grocery list
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot grocery list - list items on your grocery list
#   hubot remind me to buy <item> - add item to grocery list
#   hubot i bought <item> - mark item as purchased
#   hubot remove <item> - remove item from my grocery lists
#   hubot what have i purchased - shows what you've purchased
#
# Author:
#   parkr

module.exports = (robot) ->
  
  robot.brain.data.groceryList =
    toBuy: {},
    purchased: {}
  groceryList =
    get: ->
      Object.keys(robot.brain.data.groceryList.toBuy)
    
    getPurchased: ->
      Object.keys(robot.brain.data.groceryList.purchased)
      
    add: (item) ->
      robot.brain.data.groceryList.toBuy[item] = true
      
    remove: (item) ->
      delete robot.brain.data.groceryList.toBuy[item]
      true
      
    bought: (item) ->
      delete robot.brain.data.groceryList.toBuy[item]
      robot.brain.data.groceryList.purchased[item] = true
      
  robot.respond /grocery list$/i, (msg) ->
    list = groceryList.get().join("\n") || "No items in your grocery list."
    msg.send list
  
  robot.respond /remind me to (buy|get) (.*)/i, (msg) ->
    item = msg.match[2].trim()
    groceryList.add item
    msg.send "ok, added #{item} to your grocery list."

  robot.respond /i bought (.*)/i, (msg) ->
    item = msg.match[1].trim()
    groceryList.bought item
    msg.send "ok, marked #{item} as purchased."
  
  robot.respond /remove (.*)/i, (msg) ->
    item = msg.match[1].trim()
    groceryList.remove item
    msg.send "ok, removed #{item} from your grocery list."
  
  robot.respond /what have i purchased/i, (msg) ->
    list = groceryList.getPurchased().join("\n") || "You haven't purchased anything."
    msg.send list
