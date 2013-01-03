## Description
#   Show / Enter who is out of office
#
# Dependencies:
#   "moment": "x"
#   "underscore": "x"
#
# Configuration:
#
# Commands:
#   hubot I will be out [date]
#   hubot whoisout
#
# Notes:
#
# Author:
#  Contejious

moment = require 'moment'
_ = require 'underscore'
plugin = (robot)->
  robot.brain.on 'loaded', =>
    robot.brain.data.outList = []  unless _(robot.brain.data.outList).isArray()

  robot.respond /whoisout/i, (msg)->
    msg.send (plugin.getAbsentees robot, msg.match[1])

  robot.respond /I will be out +(.*)/i, (msg)->
    thisDate = plugin.parseDate msg.match[1]?.trim()
    if thisDate
      plugin.save robot, thisDate, msg.message
      msg.send 'ok'
    else
      msg.send 'unable to save date'

plugin.parseDate = (fuzzyDateString)->
  if (@thisDate = (moment fuzzyDateString)).isValid()
    return {start: @thisDate.toDate(), end: null}
  else
    return false

plugin.save = (robot, vacationDateRange, msg)->
  userOutList = robot.brain.data.outList
  userVacation = _(userOutList).find (item)-> item.name is msg.user.name

  if userVacation is undefined
    userOutList.push
      name: msg.user.name
      dates: [vacationDateRange.start]
  else
    unless _(userVacation.dates).some( (item)-> (moment item).format('M/D/YY') is (moment vacationDateRange.start).format('M/D/YY'))
      userVacation.dates.push vacationDateRange.start

plugin.getAbsentees = (robot, targetDate)->
  targetDate = new Date() unless targetDate?
  if _(robot.brain.data.outList).isArray() and (robot.brain.data.outList.length > 0)
    names = []
    _(robot.brain.data.outList).each (item)->
      if(_(item.dates).some( (dt)-> (moment dt).format('M/D/YY') is (moment targetDate).format('M/D/YY')))
        names.push item.name
    if names.length > 0
      names.join '\n'
    else
      return 'Nobody'
  else
    return 'Nobody'
module.exports = plugin
