# Description:
#   Show random filewise invisible
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot filmwise me - a randomly selected filmwise invisible
#   hubot filmwise bomb me <number> - filmwise invisible explosion
#
# Author:
#   mwongatemma

module.exports = (robot) ->
  robot.respond /filmwise\s*(?:me)?$/i, (msg) ->
    show_filmwise msg, 1
  robot.respond /filmwise\s+(?:bomb)\s*(?:me)?\s*(\d+)?/i, (msg) ->
    count = msg.match[1] || 5
    show_filmwise msg, count
show_filmwise = (msg, count) ->
  WEEK = 1000 * 60 * 60  * 24 * 7
  # This is the first week of images currently available.
  d1 = new Date('09/13/2010')
  d2 = new Date()
  passed = Math.floor((d2.getTime() - d1.getTime()) / WEEK)

  for i in [1..count]
    week = 501 + Math.floor(Math.random() * passed)
    image = 1 + Math.floor(Math.random() * 8)
    msg.send "http://filmwise.com/invisibles/invisible_" + (String) week + "/image_0" + (String) image + ".jpg"
