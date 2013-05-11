# Description:
#   A way to interact with the Google Custom Search API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GOOGLE_SEARCH_KEY
#   HUBOT_GOOGLE_SEARCH_CX
#
# Commands:
#   hubot (google|search)( me) <query> - returns URL's and Title's for 5 first results from custom search
#
# Notes:
#   Limits for free version is 100 queries per day per API key
#
# Author:
#   Airborn

module.exports = (robot) ->
  robot.respond /(google|search)( me)? (.*)/i, (msg) ->
    msg
      .http("https://www.googleapis.com/customsearch/v1")
      .query
        key: process.env.HUBOT_GOOGLE_SEARCH_KEY
        cx: process.env.HUBOT_GOOGLE_SEARCH_CX
        fields: "items(title,link)"
        num: 5
        q: msg.match[3]
      .get() (err, res, body) ->
        resp = "";
        results = JSON.parse(body)
        if results.error
          results.error.errors.forEach (err) ->
            resp += err.message
        else
          results.items.forEach (item) ->
            resp += item.title + " - " + item.link + "\n"

        msg.send resp
