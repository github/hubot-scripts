# Description:
#   keep-alive pings each url in the array every minute.
#   This is specifically to keep certain heroku apps from going to sleep
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_KEEP_ALIVE_FREQUENCY
#
# Commands:
#   hubot keep http://ninjas-20.herokuapp.com alive - Add inputted url to the collection of urls set to be pinged
#   hubot don't keep http://ninjas-20.herokuapp.com alive - Remove inputted url to the collection of urls set to be pinged
#   hubot what are you keeping alive - Show list of urls being kept alive
#
# Author:
#   maddox

HTTP = require "http"
URL  = require "url"

frequency = process.env.HUBOT_KEEP_ALIVE_FREQUENCY || 60000

ping = (url) ->
  parsedUrl = URL.parse(url)
  options   =
    host: parsedUrl.host
    port: 80
    path: parsedUrl.path
    method: 'GET'

  req = HTTP.request options, (res) ->
    body = ""
    res.setEncoding("utf8")
    res.on "data", (chunk) ->
      body += chunk
    res.on "end", () ->
      data =
        response:
          body: body
          status: res.statusCode

  req.on "error", (e) ->

  req.end()


module.exports = (robot) ->

  keepAlive = () ->
    robot.brain.data.keepalives ?= []

    for url in robot.brain.data.keepalives
      console.log(url)
      try
        ping(url)
      catch e
        console.log("that probably isn't a url: " + url)

    setTimeout (->
      keepAlive()
    ), frequency

  keepAlive()

  robot.respond /keep (.*) alive$/i, (msg) ->
    url = msg.match[1]

    robot.brain.data.keepalives ?= []

    if url in robot.brain.data.keepalives
      msg.send "I already am."
    else
      robot.brain.data.keepalives.push url
      msg.send "OK. I'll ping that url every " + frequency/1000 + " seconds to make sure its alive."

  robot.respond /don'?t keep (.*) alive$/i, (msg) ->
    url = msg.match[1]

    robot.brain.data.keepalives ?= []

    robot.brain.data.keepalives.splice(robot.brain.data.keepalives.indexOf(url), 1);
    msg.send "OK. I've removed that url from my list of urls to keep alive."

  robot.respond /what are you keeping alive/i, (msg) ->
    robot.brain.data.keepalives ?= []

    if robot.brain.data.keepalives.length > 0
      msg.send "These are the urls I'm keeping alive:\n" + robot.brain.data.keepalives.join('\n')
    else
      msg.send "I'm not currently keeping any urls alive. Why don't you add one?"
