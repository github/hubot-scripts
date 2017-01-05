# Description:
#   make links
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ln - Show link entries
#   hubot ln <alias> - Send source message
#   hubot ln add <alias> "<source message>" - Add link entry
#   hubot ln [rm|remove] <alias> - Remove link entry
#
# Author:
#   Yoichi-KIKUCHI
{TextMessage, User} = require "../../../hubot"

module.exports = (robot) ->
  BRAIN_KEY_LINK = "link_entry"

  robot.respond /ln$/i, (msg) ->
    messages = ""
    lnEntries = robot.brain.get BRAIN_KEY_LINK
    for lnKey, lnVal of lnEntries
      messages += (lnKey + ' -> "' + lnVal + '"\n')
    if messages isnt ""
      msg.send messages

  robot.respond /ln (.+)$/i, (msg) ->
    text = msg.match[1]

    if text.indexOf("add ") is 0
      ln.add msg, text
    else if text.indexOf("rm ") is 0 || text.indexOf("remove ") is 0
      ln.remove msg, text
    else
      ln.command msg, text

  ln = {}
  ln.add = (msg, text) =>
    match = text.match /add (.+) "(.+)"$/i
    lnKey = match[1]
    lnVal = match[2]
    lnEntries = robot.brain.get BRAIN_KEY_LINK
    lnEntries = if lnEntries? then lnEntries else {}
    lnEntries[lnKey] = lnVal
    robot.brain.set BRAIN_KEY_LINK, lnEntries
    msg.send "Add link: " + lnKey + ' -> "' + lnVal + '"'

  ln.remove = (msg, text) =>
    match = text.match /(?:rm|remove) (.+)$/i
    lnKey = match[1]
    lnEntries = robot.brain.get BRAIN_KEY_LINK
    lnEntries = if lnEntries? then lnEntries else {}
    delete lnEntries[lnKey]
    robot.brain.set BRAIN_KEY_LINK, lnEntries
    msg.send "Remove link: " + lnKey

  ln.command = (msg, text) =>
    lnKey = text
    lnEntries = robot.brain.get BRAIN_KEY_LINK
    lnEntries = if lnEntries? then lnEntries else {}
    lnCmd = lnEntries[lnKey]
    author = robot.brain.userForName(msg.message.user.reply_to) or new User(msg.message.user.reply_to)
    author.reply_to = msg.message.user.reply_to
    author.room = msg.message.user.room
    message = lnCmd
    robot.adapter.receive new TextMessage(author, message)
