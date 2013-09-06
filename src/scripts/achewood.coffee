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
#   hubot achewood <keyword> - Achewood comic for keyword
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

  robot.respond /achewood\s?((?:0[1-9]|1[0-2]).?(?:0[1-9]|[1-2][0-9]|3[0-1]).?(?:20\d{2})$|.*)?/i, (msg) ->
    arg = msg.match[1]
    if arg == undefined
      msg.http("http://www.ohnorobot.com/random.pl?comic=636")
          .get() (err, res, body) ->
            fetchAchewood(msg, res.headers['location'])
    else if arg == "current"
      fetchAchewood(msg, "http://achewood.com")
    else if arg.match /\d{2}.?\d{2}.?\d{4}/
      date = arg.replace /\D/g, ''
      fetchAchewood(msg, withDate(date))
    else
      query = arg
      msg.http("http://www.ohnorobot.com/index.pl?comic=636&lucky=1&s=#{query}")
          .get() (err, res, body) ->
            fetchAchewood(msg, res.headers['location'])

  robot.respond /.*saddest thing\?*/i, (msg) ->
    saddest = msg.random ["06022003", "11052001", "09052006", "07302007"]
    fetchAchewood(msg, withDate(saddest))
