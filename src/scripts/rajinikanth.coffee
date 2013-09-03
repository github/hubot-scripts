# Description:
#   Rajinikanth is Chuck Norris of India, witness his awesomeness.
#
# Dependencies:
#   "cheerio": "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot rajinikanth|rajini -- random Rajinikanth awesomeness
#   hubot rajinikanth|rajini me <user> -- let's see how <user> would do as Rajinikanth
#
# Author:
#   juzerali

cheerio = require('cheerio')
url = "http://rajinikanthfacts.com/"

module.exports = (robot) ->
  robot.respond /(?:rajinikanth|rajini)(?: me)? ?(.*)/i, (msg)->
    user = msg.match[1]
    msg.http(url)
      .get() (err, res, body) ->
        if err
          msg.send "Rajinikanth says: #{err}"
        else
          $ = cheerio.load(body)
          fact = $(".fact").find(".ftext").text()

          if !!user
            fact = fact.replace /raji?ni(kanth?)?/ig, user
          msg.send fact