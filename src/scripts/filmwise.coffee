# Description:
#   Show random filewise invisible
#
# Dependencies:
#   "cheerio": "0.10.5"
#
# Configuration:
#   None
#
# Commands:
#   filmwise me - a randomly selected filmwise invisible
#   filmwise bomb <number> - filmwise invisible explosion!
#   filmwise answer (or cheat) - show the answer to the last filmwise shown
#
# Author:
#   mwongatemma, lroggendorff

$ = require "cheerio"

module.exports = (robot) ->
  robot.respond /filmwise\s*(?:me)?$/i, (msg) ->
    robot.brain.data.lastfilm = show_filmwise msg, 1
  robot.respond /filmwise\s+(?:bomb)\s*(?:me)?\s*(\d+)?/i, (msg) ->
    count = msg.match[1] || 5
    robot.brain.data.lastfilm = show_filmwise msg, count
  robot.respond /filmwise\s+(?:answer|cheat)?$/i, (msg) ->
    title = ""
    answerUrl = robot.brain.data.lastfilm.replace /\/image_0\d+\.jpg$/, "a.shtml"
    answerImgSrc = robot.brain.data.lastfilm.match /(invisible_\d+\/image_0\d+)\.jpg$/
    answerImgSrc = answerImgSrc[1] + "a.jpg"
    msg.http(answerUrl)
      .get() (err, res, body) ->
        msg.send $(body).find('img[src$="' + answerImgSrc + '"]').next().next().text()
    msg.send robot.brain.data.lastfilm.replace /\.jpg$/, "a.jpg"
show_filmwise = (msg, count) ->
  WEEK = 1000 * 60 * 60  * 24 * 7
  # This is the first week of images currently available.
  d1 = new Date('09/13/2010')
  d2 = new Date()
  passed = Math.floor((d2.getTime() - d1.getTime()) / WEEK)
  lastFilm = ""

  for i in [1..count]
    week = 501 + Math.floor(Math.random() * passed)
    image = 1 + Math.floor(Math.random() * 8)
    lastFilm = "http://filmwise.com/invisibles/invisible_" + (String) week + "/image_0" + (String) image + ".jpg"
    msg.send lastFilm
  return lastFilm
