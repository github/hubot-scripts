# Description:
# This script will allow you to keep track of humanities score
#
# Commands:
# hubot humanity +\d
# hubot humanity -\d
#
# Author
#   Brent Montague

module.exports = (robot) ->
  robot.hear /humanity (\+|\-|)(\d+)/i, (msg) ->
    humanity = new Humanity robot
    parsedValue = parseInt (msg.match[1] + msg.match[2])
    humanity.judge(parsedValue)
    msg.reply 'Humanity: ' + humanity.score()

class Humanity
  constructor: (robot) ->
    robot.brain.data.humanity ?= {score: 0}
    @humanity_ = robot.brain.data.humanity

  judge: (score) ->
    @humanity_.score += score

  score: () ->
    @humanity_.score

