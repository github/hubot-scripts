# Description:
#   Android os version usage by percentage
#
# Dependencies:
#   "phantom": "0.5.2"
#   "cheerio": "0.12.1"
# 
# Configuration:
#   None
#
# Commands:
#   hubot android usage
#
# Author:
#   mikebob

phantom = require("phantom")
cheerio = require("cheerio")

codenames = []
api = []
url = "http://developer.android.com/about/dashboards/index.html"

module.exports = (robot) ->

  last = (arr) ->
    return arr[arr.length-1] if arr.length > 0

  rpad = (str, length) ->
    while str.length < length
      str = str + '.'
    return str      

  robot.respond /android usage?$/i, (msg) ->
    phantom.create (ph) ->
      ph.createPage (page) ->
        page.open url, (status) ->
          page.evaluate ()->
            return {
              message: document.getElementById("version-chart").innerHTML
            }
          , (result)->
            $ = cheerio.load result.message, { ignoreWhitespace: true };
            res = $("tr").slice(1).map (i, el) ->
              v = cheerio.load this
              tds = v("td")
              
              if tds.length is 3
                codenames.push last codenames # repeat codename
                api.push tds.eq(1).html()
              else
                codenames.push tds.eq(1).html()
                api.push tds.eq(2).html()

              percent = tds.last().html()
              nameapi = rpad "#{last codenames} [#{last api}] ", 30
              "#{nameapi} #{percent}" 
            .join '\n'

            msg.send "#{res}"
            ph.exit()
