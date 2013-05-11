# Description:
#   Displays the current avalanche forecast for norway.
#
# Dependencies:
#   "jsdom": "0.2.14"
# Configuration:
#   None
#
# Commands:
#   hubot avy me - Return a breakdown of the avalanche forecast from varsom.no
#
# Author:
#   Alastair Brunton

jsdom = require 'jsdom'

getScores = ($, cb) ->
  results = []
  area_scores = {}
  trs = $("tr")
  tr_length = trs.length

  trs.each ((index) ->
    getRiskValues($, $(this), (err, values) ->
      results.push values
      if results.length == tr_length - 1
        cb null, results
      else
        # do nothing
    )
  )

getRiskValues = ($, element, cb) ->
  riskValues = []
  element.children("td.hazard").each((index) ->
    riskValues.push $(this).text().trim()
    if riskValues.length == 3
      cb null, riskValues
    else
      # do nothing
  )

getPlaces = ($, cb) ->
  locations = $("span.location")
  locationNames = []
  numLocations = locations.length
  locations.each((index) ->
    $(this).children().each((index2) ->
      locationNames.push $(this).text()
      if locationNames.length == numLocations
        cb null, locationNames
      else
        # do nothing
    )
  
  )

joinArs = (places, scores) ->
  joinedAr = []
  i = 0
  for place in places
    score = scores[i].join(" ")
    joinedAr.push("#{place} #{score}")
    i = i + 1
  joinedAr.join("\n")


module.exports = (robot)->
  robot.respond /avy me/i, (msg) ->
    jsdom.env("http://varsom.no/Snoskred/", ['http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js'],
    (errors, window) ->
      $ = window.$

      getScores($, (err, scores) ->
        getPlaces($, (err, places) ->
          avyReport = joinArs(places, scores)
          msg.send avyReport
        )
      )
    )
    




