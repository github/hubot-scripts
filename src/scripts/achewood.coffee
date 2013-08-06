# Description
#   Philippe is standing on it.
#
# Dependencies:
#  "htmlparser": "1.7.6"
#  "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot achewood - A random Achewood comic
#   hubot achewood current - The most recent Achewood comic
#   hubot achewood <date> - Achewood comic from <date> - mm/dd/yyyy format
#   hubot saddest thing - The saddest thing, according to Lie Bot
#
# Author:
#   1000hz

htmlparser = require "htmlparser"
Select = require("soupselect").select

module.exports = (robot) ->
  withDate = (date) ->
    "http://achewood.com/index.php?date=#{date}"

  fetchAchewood = (msg, url) ->
    msg.http(url).get() (err, res, body) ->
      handler = new htmlparser.DefaultHandler()
      parser = new htmlparser.Parser(handler)
      parser.parseComplete(body)

      img = Select handler.dom, "img.comic"
      comic = img[0].attribs

      msg.send "http://achewood.com" + comic.src + "#.png"
      msg.send comic.title

  robot.respond /achewood\s?((0[1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1]).(20\d{2})$|current)?/i, (msg) ->
    if msg.match[1] == undefined
      msg.http("http://www.ohnorobot.com/random.pl?comic=636")
          .get() (err, res, body) ->
            fetchAchewood(msg, res.headers['location'])
    else if msg.match[1] == "current"
      fetchAchewood(msg, "http://achewood.com")
    else
      date = "#{msg.match[2]}#{msg.match[3]}#{msg.match[4]}"
      fetchAchewood(msg, withDate(date))

  robot.respond /.*saddest thing\?*/i, (msg) ->
    saddest = msg.random ["06022003", "11052001", "09052006", "07302007"]
    fetchAchewood(msg, withDate(saddest))
