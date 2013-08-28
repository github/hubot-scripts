# Description
#   Tell a poem from the collective yearning of humanity, based on their Google searches.
#   Inspired by http://www.googlepoetics.com/
#
# Dependencies:
#   "jsdom": "0.8.4"
#
# Configuration:
#   None
#
# Commands:
#   hubot poem <about>              - Tell us a poem that starts like this
#   hubot poem <# of lines> <about> - Tell a poem in this many lines
#
# Notes:
#
# Author:
#   roblingle
jsdom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /poem(ify)?( (\d))? (.*)/i, (msg) ->
    lines = msg.match[3] || 3
    about = msg.match[4]

    getSuggestions msg, about, (suggestions, err) -> 
      msg.send err || suggestions[0...lines].join('\n')

getSuggestions = (msg, term, cb) ->
    msg.http("https://clients1.google.com/complete/search")
      .query(output: "toolbar", hl: "en", q: term)
      .get() (err, res, body) ->
        try
          suggestions = []
          for suggestion in jsdom.jsdom(body).getElementsByTagName('suggestion')
            suggestion = suggestion.getAttribute('data')
            suggestions.push suggestion unless suggestion.match(/lyrics/)
        catch error
          err = "I don't feel like writing poems today"
        cb(suggestions, err)
