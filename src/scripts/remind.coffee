# Forgetful? Add reminders.
#
# remind me in <time> to <action>    - Set a reminder in <time> to do an <action>
#                                      <time> is in the format 1 day, 2 hours, 5 minutes etc
#                                      Time segments are optional, as are commas

class Reminders
  constructor: ->
    @cache = []
    @current_timeout = null

  add: (reminder) ->
    @cache.push reminder
    @cache.sort (a, b) -> a.due - b.due
    @queue()

  queue: ->
    clearTimeout @current_timeout if @current_timeout
    if @cache.length > 0
      now = new Date().getTime()
      trigger = =>
        reminder = @cache.shift()
        reminder.msg.send reminder.msg.message.user.name + ', you asked me to remind you to ' + reminder.action
        @queue()
      @current_timeout = setTimeout trigger, @cache[0].due - now

class Reminder
  constructor: (@msg, @time, @action) ->
    @time.replace(/^\s+|\s+$/g, '')

    periods =
      weeks:
        value: 0
        regex: "weeks?"
      days:
        value: 0
        regex: "days?"
      hours:
        value: 0
        regex: "hours?|hrs?"
      minutes:
        value: 0
        regex: "minutes?|mins?"
      seconds:
        value: 0
        regex: "seconds?|secs?"
    
    for period of periods
      pattern = new RegExp('^.*?([\\d\\.]+)\\s*(?:(?:' + periods[period].regex + ')).*$', 'i')
      matches = pattern.exec(@time)
      periods[period].value = parseInt(matches[1]) if matches

    @due = new Date().getTime()
    @due += ((periods.weeks.value * 604800) + (periods.days.value * 86400) + (periods.hours.value * 3600) + (periods.minutes.value * 60) + periods.seconds.value) * 1000

  dueDate: ->
    dueDate = new Date @due
    dueDate.toLocaleString()

module.exports = (robot) ->

  reminders = new Reminders

  robot.respond /remind me in ((?:(?:\d+) (?:weeks?|days?|hours?|hrs?|minutes?|mins?|seconds?|secs?)[ ,]*(?:and)? +)+)to (.*)/i, (msg) ->
    time = msg.match[1]
    action = msg.match[2]
    reminder = new Reminder msg, time, action
    reminders.add reminder
    msg.send 'I\'ll remind you to ' + action + ' on ' + reminder.dueDate()

