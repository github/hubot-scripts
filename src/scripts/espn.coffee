# Description:
#   Grab a headline from ESPN
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ESPN_ACCOUNT_KEY
#
# Commands:
#   hubot espn - Displays a random headline from ESPN.com
#
# Author:
#   mjw56

espnApiKey = process.env.HUBOT_ESPN_ACCOUNT_KEY
unless espnApiKey
  throw "You must enter your HUBOT_ESPN_ACCOUNT_KEY in your environment variables"

module.exports = (robot) ->
  robot.respond /espn/i, (msg) ->
    search = escape(msg.match[2])
    msg.http('http://api.espn.com/v1/sports/news/headlines?apikey=' + espnApiKey)
      .get() (err, res, body) ->
        result = JSON.parse(body)

        if result.headlines.count <= 0
          msg.send "Couldn't find any headlines"
          return

        urls = [ ]
        for child in result.headlines
          urls.push(child.headline + "-  " + child.links.web.href)

        rnd = Math.floor(Math.random()*urls.length)
        msg.send urls[rnd]
