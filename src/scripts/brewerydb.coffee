# Description:
#   BreweryDB API
#
# Dependencies:
#   None
#
# Configuration:
#   BREWERYDB_API_KEY
#
# Commands:
#   hubot beer me <beer name> - Information about a beer
#
# Author:
#   greggroth

module.exports = (robot) ->
  robot.respond /beer me (.*)/i, (msg) ->
    unless process.env.BREWERYDB_API_KEY?
      msg.send "Please specify your BreweyDB API key in BREWERYDB_API_KEY"
      return
    msg.http("http://api.brewerydb.com/v2/search")
      .query
        type: "beer"
        withBreweries: "Y"
        key: process.env.BREWERYDB_API_KEY
        q: msg.match[1].replace(" ", "+")
      .get() (err, res, body) ->
          data = JSON.parse(body)['data']
          if data
            beer = data[0]
          else
            msg.send "No beer found"
            return
            
          response = beer['name']
          if beer['breweries']?
            response += " (#{beer['breweries'][0]['name']})"
          if beer['style']?
            response += "\n#{beer['style']['name']}"
          if beer['abv']?
            response += "\nABV:  #{beer['abv']}%"
          if beer['ibu']?
            response += "\nIBU:  #{beer['ibu']}"
          if beer['description']?
            response += "\nDescription:   #{beer['description']}"
          if beer['foodPairings']?
            response += "\nFood Pairings:   #{beer['foodPairings']}"
          msg.send response
