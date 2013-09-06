# Description:
#   Find a yacht. Because, you know, you need one.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   yacht me - A random yacht from http://www.yachtworld.com
#
# Author:
#   artfuldodger
#
# Tags:
#   fun
#   boats

URL = "http://www.yachtworld.com/core/listing/cache/searchResults.jsp?fromPrice=1,000,000&slim=quick&searchtype=homepage&Ntk=boatsEN&sm=3&pricderange=$1,000,000%20&cit=true&currencyid=100&luom=126&No="

module.exports = (robot) ->
  robot.respond /yacht me/i, (msg) ->
    @robot.http(url(msg))
      .get() (err, res, body) ->
        boat = new Boat(body)
        msg.send boat.image()
        msg.send boat.infoLine()

url = (msg) ->
  URL + boatNumber(msg)

boatNumber = (msg) ->
  msg.random([1..1000])

class Boat
  constructor: (@html) ->

  image: ->
    originalSource = @relevantDiv().match(/<img src="(.+)"/)[1]
    originalSource.replace(/w=(\d+)/, 'w=800').replace(/h=(\d+)/, 'h=800')

  infoLine: ->
    [@name(), @price(), @link()].join(' - ')

  link: ->
    'http://www.yachtworld.com' + @relevantDiv().match(/<a href="(\/boats\/.+)">/)[1].replace(/".*/, '')

  name: ->
    @sanitizeHtml(@relevantDiv().match(/<h2 id="searchResultsDetailsRowTitle">(.|\n)+?<a href.*>(.|\n)+?<\/a>/m)[0])

  price: ->
    @sanitizeHtml(@relevantDiv().match(/<div id="searchResultsDetailsRowPrice">(.|\n)+?<\/div>/)[0])

  relevantDiv: ->
    @html.match(/<div id="searchResultsDetailsRow">(.|\n)*<\/div>/m)[0]

  sanitizeHtml: (html) ->
    @removeGratuitousWhitespace(@replaceNbsp(@stripTags(html)))

  stripTags: (html) ->
    html.replace(/<\/?([a-z][a-z0-9]*)\b[^>]*>?/gi, '')

  removeGratuitousWhitespace: (html) ->
    html.replace(/\s+/g, ' ')

  replaceNbsp: (html) ->
    html.replace(/&nbsp;/g, ' ')
