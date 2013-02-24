# Description:
#   Webutility returns title of urls
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#   "jsdom": "0.2.14"
#
# Configuration:
#   HUBOT_BITLY_USERNAME
#   HUBOT_BITLY_API_KEY
#
# Commands:
#   None
#
# Author:
#   KevinTraver

Select     = require("soupselect").select
HtmlParser = require "htmlparser"
JSDom      = require "jsdom"

# Decode HTML entities
unEntity = (str) ->
    e = JSDom.jsdom().createElement("div")
    e.innerHTML = str
    if e.childNodes.length == 0 then "" else e.childNodes[0].nodeValue

module.exports = (robot) ->
  robot.hear /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/i, (msg) ->
    url = msg.match[0]
    httpResponse = (url) ->
      msg
        .http(url)
        .get() (err, res, body) ->
          if res.statusCode is 301 or res.statusCode is 302
            httpResponse(res.headers.location)
          else if res.statusCode is 200
            if res.headers['content-type'].indexOf('text/html') != 0
              return

            handler = new HtmlParser.DefaultHandler()
            parser  = new HtmlParser.Parser handler
            parser.parseComplete body

            # abort if soupselect runs out of stack space
            try
              results = (Select handler.dom, "head title")
            catch RangeError
              return

            processResult = (elem) ->
                unEntity(elem.children[0].data.replace(/(\r\n|\n|\r)/gm,"").trim())
            if results[0]
              msg.send processResult(results[0])
            else
              results = (Select handler.dom, "title")
              if results[0]
                msg.send processResult(results[0])
          else
            msg.send "Error " + res.statusCode

    httpBitlyResponse = (url) ->
      msg
        .http("http://api.bitly.com/v3/info")
        .query
          login: process.env.HUBOT_BITLY_USERNAME
          apiKey: process.env.HUBOT_BITLY_API_KEY
          shortUrl: url
          format: "json"
        .get() (err, res, body) ->
          response = JSON.parse body
          responseTitle = response.data.info[0].title.replace(/(\r\n|\n|\r)/gm,"").trim()
          if responseTitle
            msg.send if response.status_code is 200 then responseTitle else response.status_txt
          else
            httpResponse(url)
    if url.match /https?:\/\/(mobile\.)?twitter\.com/i
      console.log "Twitter link; ignoring"
    else if url.match /^http\:\/\/bit\.ly/
      httpBitlyResponse(url)
    else
      httpResponse(url)
