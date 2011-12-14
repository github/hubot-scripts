# A way to interact with the Google Custom Search API.
# This script reqire to env variables to be set:
# HUBOT_GOOGLE_SEARCH_KEY: Google Custom Search API Key from https://code.google.com/apis/console/
# HUBOT_GOOGLE_SEARCH_CX: Google Custom Search Engine ID from http://www.google.com/cse/manage/all
#
# Limits for free version is 100 queries per day per API key.
#
# (google|search)( me) <query> - returns URL's and Title's for 5 first results from custom search#
#
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
