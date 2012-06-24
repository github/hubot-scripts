# Description:
#   Tracks when stuff is due
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot deadlines - List what you have due
#   hubot add deadline 2011-10-30 Thing - Add a deadline for October 10, 2011
#   hubot remove deadline Thing - Remove a deadline named "Thing"
#   hubot clear deadlines - Remove all the deadlines
#
# Author:
#   jmhobbs

module.exports = (robot) ->

  robot.respond /(create|add|set) deadline (\d\d\d\d-\d\d-\d\d) (.*) ?$/i, (msg) ->
    due = msg.match[2]
    what = msg.match[3]

    robot.brain.data.deadlines ?= []
    
    robot.brain.data.deadlines.push { what: what, due: due } 
    msg.send 'Got it! "' + what + '" is due on ' + due

  robot.respond /(clear|flush) deadlines/i, (msg) ->
    robot.brain.data.deadlines = []
    msg.send "Deadlines cleared. Go do whatever you want."

  robot.respond /(delete|remove|complete) deadline (.*) ?$/i, (msg) ->
    what = msg.match[2]

    robot.brain.data.deadlines ?= []

    length_before = robot.brain.data.deadlines.length

    index_of = -1
    for deadline, i in robot.brain.data.deadlines
      if deadline.what == what
        index_of = i
   
    robot.brain.data.deadlines.splice( index_of, 1 ) if -1 != index_of
    
    if length_before > robot.brain.data.deadlines.length
      msg.send 'Removed deadline "' + what + '", nice job!'
    else
      msg.send 'I couldn\'t find that deadline.'
   

  robot.respond /deadlines/i, (msg) ->
    robot.brain.data.deadlines ?= []

    if robot.brain.data.deadlines.length > 0
      deadlines = robot.brain.data.deadlines.map (deadline) ->
        today = new Date()
        due_date = new Date( deadline.due )
        days_passed = Math.round( ( due_date.getTime() - today.getTime() ) / 86400000 )
        
        interval_string = days_passed + ' days left'
        interval_string = ( -1 * days_passed ) + ' days overdue' if days_passed < 0
        interval_string = 'due today' if days_passed == 0

        '"' + deadline.what + '" is due on ' + deadline.due + ' (' + interval_string + ')'
      
      msg.send "Here are your upcoming deadlines:\n\n" + deadlines.join "\n"
      
    else
      msg.send "I'm not currently tracking any deadlines. Why don't you add one?"
