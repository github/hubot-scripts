# Generates commands to track days since an event
#
# it's been <number> days since <event> - Set the day when the event happened
# <event> on <date> - Set the date the event happened (yyyy-mm-dd)
# how long since <event>? - Display the number of days since the event

module.exports = (robot) ->
  robot.respond /(.*?) on ((19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]))/, (msg) ->
    event = msg.match[1]
    date = new Date(msg.match[2])
    robot.brain.data.days_since ||= {}
    robot.brain.data.days_since[event] = date
    msg.send "okay, " + event + " was on " + msg.match[2]

  robot.respond /it's been (\d+) days since\s+(.*?)[.?!]?$/i, (msg) ->
    date = new Date
    date.setTime(date.getTime() - (parseInt(msg.match[1])*1000*24*60*60))
    date.setHours(0,0,0,0)
    robot.brain.data.days_since ||= {}
    robot.brain.data.days_since[msg.match[2]] = date
    msg.send "okay, it's been " + msg.match[1] + " days since " + msg.match[2]

  robot.respond /how long since\s+(.*?)\??$/i, (msg) ->
    if robot.brain.data.days_since && robot.brain.data.days_since[msg.match[1]]
      date = robot.brain.data.days_since[msg.match[1]]
      days_since = Math.floor((new Date - new Date(date).getTime()) / (1000*24*60*60))
      msg.send "it's been " + days_since + " days since " + msg.match[1]
    else
      msg.send "I don't recall that event"
