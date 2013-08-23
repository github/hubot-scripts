# Description
#   Set countdown date and retreive countdown (number of days remaining).
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   countdown set #meetupname# #datestring# e.g. countdown set punerbmeetup 21 Jan 2014
#   countdown [for] #meetupname# e.g. countdown punerbmeetup
#   countdown list 
#   countdown delete #meetupname# e.g. countdown delete seattlerbmeetup
#   countdown clear
#
# Notes:
#   None
#
# Author:
#   anildigital

module.exports = (robot) ->

  # Get countdown message
  getCountdownMsg = (countdownKey) ->
    now = new Date()
    eventTime = new Date(robot.brain.data.countdown[countdownKey].date)
    gap = eventTime.getTime() - now.getTime()
    gap =  Math.floor(gap / (1000 * 60 * 60 * 24));
    "Only #{gap} days remaining till #{countdownKey}!"

  robot.hear /countdown set (\w+) (.*)/i, (msg) ->
    robot.brain.data.countdown or= {}

    dateString = msg.match[2];

    try 
      date = new Date(dateString);
      if date == "Invalid Date"
        throw "Invalid date passed"
      countdownKey = msg.match[1]

      robot.brain.data.countdown[countdownKey] = {"date" : date.toDateString()} 
      msg.send "Countdown set for #{countdownKey} at #{date.toDateString()}"
      msg.send getCountdownMsg(countdownKey)  if robot.brain.data.countdown.hasOwnProperty(countdownKey)
    catch error
        console.log(error.message)
        msg.send "Invalid date passed!"

  robot.hear /countdown list/i, (msg) ->
    countdowns = robot.brain.data.countdown;
    for countdownKey of countdowns
      msg.send countdownKey + " -> " + new Date(countdowns[countdownKey].date).toDateString() +
        " -> " + getCountdownMsg(countdownKey) if countdowns.hasOwnProperty(countdownKey)

  robot.hear /(countdown)( for)? (.*)/, (msg) ->
    countdownKey = msg.match[3]
    countdowns = robot.brain.data.countdown;
    msg.send getCountdownMsg(countdownKey)  if countdowns.hasOwnProperty(countdownKey)

  robot.hear /countdown clear/i, (msg) ->
    robot.brain.data.countdown = {}
    msg.send "Countdowns cleared"

  robot.hear /countdown delete (.*)/i, (msg) ->
    countdownKey = msg.match[1]
    if robot.brain.data.countdown.hasOwnProperty(countdownKey)
      delete robot.brain.data.countdown[countdownKey]
      msg.send "Countdown for #{countdownKey} deleted."
    else
      msg.send "Countdown for #{countdownKey} does not exist!"

  robot.hear /countdown set$|countdown help/i, (msg) ->
    msg.send "countdown set #meetupname# #datestring# e.g. countdown set PuneRubyMeetup 21 Jan 2014"
    msg.send "countdown [for] #meetupname# e.g. countdown PuneRubyMeetup"
    msg.send "countdown list"
    msg.send "countdown delete #meetupname# e.g. countdown delete HashTagMeetup"
    msg.send "countdown clear"
