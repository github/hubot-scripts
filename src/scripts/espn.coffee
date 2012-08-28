# Description:
#   Grab a headline from ESPN through querying hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ESPN_ACCOUNT_KEY
#
# Commands:
#   hubot espn headline - Displays a random headline from ESPN.com
#   hubot espn mlb <name of team> - Displays ESPN.com team homepage
#
# Author:
#   mjw56

espnApiKey = process.env.HUBOT_ESPN_ACCOUNT_KEY
unless espnApiKey
  throw "You must enter your HUBOT_ESPN_ACCOUNT_KEY in your environment variables"

module.exports = (robot) ->
  robot.respond /espn headline/i, (msg) ->
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

  robot.respond /(espn)( mlb)? (.*)/i, (msg) ->
    msg.http('http://api.espn.com/v1/sports/baseball/mlb/teams?apikey=' + espnApiKey)
      .get() (err, res, body) ->
        result = JSON.parse(body)	

        for child in result.sports[0].leagues[0].teams
          team = child.name.toLowerCase()
          city = child.location.toLowerCase()
          input = msg.match[3].toLowerCase()

          if team is input || city is input
            msg.send 'Team news for the '+ child.location + ' ' + child.name + '- ' + child.links.web.teams.href
