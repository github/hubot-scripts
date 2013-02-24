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

  robot.respond /(?:I am|I'm|I will be) out +(.*)/i, (msg)->
    thisDate = plugin.parseDate msg.match[1]?.trim()
    if thisDate
      plugin.save robot, thisDate, msg.message
      msg.send "ok, #{msg.message.user.name} is out on #{thisDate}"
    else
      msg.send 'unable to save date'

  robot.respond /when is (.*)/i, (msg)->
    msg.send plugin.parseDate msg.match[1]?.trim()

plugin.parseDate = (fuzzyDateString)->
  fuzzyDateString = fuzzyDateString.toLowerCase()
  if fuzzyDateString.split(" ")[0] is "next"
    plusOneWeek = true
    fuzzyDateString = fuzzyDateString.split(" ")[1]
  day = 1000*60*60*24
  week = day*7
  switch fuzzyDateString
    when "tomorrow"
      return new Date((new Date).getTime() + day)
    when "today"
      return new Date()
    when "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"
      days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
      date = new Date()
      date = new Date(date.getTime() + day) until days[date.getDay()] == fuzzyDateString
      date = new Date(date.getTime() + week) if plusOneWeek
      return date
    else
      if (@thisDate = (moment fuzzyDateString)).isValid()
        return @thisDate.toDate()
      else
        return false

plugin.save = (robot, date, msg)->
  userOutList = robot.brain.data.outList
  userVacation = _(userOutList).find (item)-> item.name is msg.user.name

  if userVacation is undefined
    userOutList.push
      name: msg.user.name
      dates: [date]
  else
    unless _(userVacation.dates).some( (item)-> (moment item).format('M/D/YY') is (moment date).format('M/D/YY'))
      userVacation.dates.push date

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
