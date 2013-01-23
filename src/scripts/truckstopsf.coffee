# Description:
#   Find out what food trucks are at Truck Stop SF today
#   See http://truckstopsf.com
#
# Dependencies:
#   "underscore": "*"
#
# Configuration:
#   None
#
# Commands:
#   hubot truckstopsf - get just the names of the food trucks today
#   hubot truckstopsf details|deets - get food truck names and details
#   hubot truckstopsf! - get food truck names and details
#
# Author:
#   chris

_ = require 'underscore'

data_by_matcher = (input, matcher) ->
  get_data = (match.match(matcher).slice(1) for match in input)
  _.flatten(get_data)

module.exports = (robot) ->
  robot.respond /truckstopsf\s?(!|details|deets)?/i, (res) ->
    d = new Date()
    utc = d.getTime() + (d.getTimezoneOffset() * 60000)
    pstDate = new Date(utc + (3600000*-8));
    today = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][pstDate.getDay()]

    if today is 'Sunday' or today is 'Saturday'
      res.send "Sorry, the trucks aren't there on weekend"
    else
      res.http("http://www.truckstopsf.com/").get() (err, _, body) ->
        return res.send "Sorry, the trucks are out of gas or something." if err
        show_details = res.match[1]?
        body = body.replace(/\r|\n/g, ' ')
        matches = body.match(new RegExp("<h3>#{today}<\/h3>(.+?)<\/div>",'i'))
        if !matches? || matches[1].match("There are no events") || matches[1].match("There are no food trucks to display")
          return res.send "Seems there may be no trucks today - check http://www.truckstopsf.com/"

        matches = matches[1].match(new RegExp("<p><strong>.+?<\/strong>.+?<\/p>",'gi'))
        matcher = if show_details
            "<p><strong>(.+)<\/strong> - (.*)<\/p>"
          else
            "<p><strong>(.+)<\/strong>"
        matches = data_by_matcher(matches, matcher)
        if matches?
          trucks = (match.replace("&#39;", "'").replace("&amp;", "&") for match in matches)
          if show_details
            truck_details = "Today's trucks:"
            while trucks.length > 0
              truck_details += "\n* #{trucks.splice(0,2).join(': ')}"
            res.send truck_details
          else
            res.send "Today's trucks: #{trucks.slice(0, -1).join(', ') } and #{trucks[trucks.length - 1]}"
        else
          res.send "Hmm, couldn't parse the trucks web page - try http://www.truckstopsf.com/"
