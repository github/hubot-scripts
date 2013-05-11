# Description
#   Status is a simple user status message updater
#
# Dependencies:
#   "underscore": "1.3.3"
#
# Configuration:
#   None
#
# Commands:
#   hubot away <away_message> - Sets you as "away" and optionally sets an away
#                        message. While away, anybody who mentions you
#                        will be shown your away message. Remember AIM?
#
#   hubot return - Removes your away flag & away message
#
#   hubot status <status_message> - Sets your status to status_message.
#
#   hubot status <username> - Tells you the status of username
#
#   Shortcuts Commands:
#     hubot a <away_message>
#     hubot r
#     hubot s <status_message>
#     hubot s <username>
#
# Notes:
#   We opted to used the '/<trigger>' syntax in favor of the 'hubot <trigger>'
#   syntax, because the commands are meant to be convenient. You can always
#   change it to use the 'hubot <trigger>' syntax by tweaking the code a bit.
#
# Author:
#   MattSJohnston

module.exports = (robot) ->

  _ = require 'underscore'

  robot.respond /(away|a$|a ) ?(.*)?/i, (msg) ->
    hb_status = new Status robot
    hb_status.update_away msg.message.user.name, msg.match[2]
    msg.send msg.message.user.name + " is away."

  robot.respond /(status|s)( |$)(.*)?/i, (msg) ->
    hb_status = new Status robot
    if !msg.match[3]?
      hb_status.remove_status msg.message.user.name
      msg.send msg.message.user.name + " has no more status."
    else if (_.any (_.values _.pluck robot.brain.users, 'name'), (val) -> return val.toLowerCase() == msg.match[3].toLowerCase())
      if hb_status.statuses_[msg.match[2].toLowerCase()]?
        msg.send msg.match[3] + "'s status: " + hb_status.statuses_[msg.match[3].toLowerCase()]
      else
        msg.send msg.match[3] + " has no status set"
    else
      hb_status.update_status msg.message.user.name, msg.match[3]
      msg.send msg.message.user.name + " has a new status."

  robot.respond /statuses?/i, (msg) ->
    hb_status = new Status robot
    message = for user, s of hb_status.statuses_
      "#{user}: #{s}"
    msg.send message.join "\n"

  robot.respond /(return|r$|r ) ?(.*)?/i, (msg) ->
    hb_status = new Status robot
    hb_status.update_away msg.message.user.name, null
    msg.send msg.message.user.name + " has returned."

  robot.hear /(^\w+\s?\w+\s?\w+):/i, (msg) ->
    hb_status = new Status robot
    mention = msg.match[1]
    if hb_status.aways_[mention.toLowerCase()]?
      msg.reply mention + " is away: " + hb_status.aways_[mention.toLowerCase()]

class Status
  constructor: (robot) ->
    robot.brain.data.statuses ?= {}
    robot.brain.data.aways ?= {}
    @statuses_ = robot.brain.data.statuses
    @aways_ = robot.brain.data.aways

  update_status: (name, message) ->
    @statuses_[name.toLowerCase()] = message

  remove_status: (name) ->
    delete @statuses_[name.toLowerCase()]

  update_away: (name, message) ->
    @aways_[name.toLowerCase()] = message
