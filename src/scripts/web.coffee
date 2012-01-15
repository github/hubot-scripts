# Webutility
#
# returns title of urls

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

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
            handler = new HtmlParser.DefaultHandler()
            parser  = new HtmlParser.Parser handler
            parser.parseComplete body
            results = (Select handler.dom, "head title")
            if results[0]
              msg.send results[0].children[0].data.replace(/(\r\n|\n|\r)/gm,"")
            else
              results = (Select handler.dom, "title")
              if results[0]
                msg.send results[0].children[0].data.replace(/(\r\n|\n|\r)/gm,"")
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
          responseTitle = response.data.info[0].title.replace(/(\r\n|\n|\r)/gm,"")
          if responseTitle
            msg.send if response.status_code is 200 then responseTitle else response.status_txt
          else
            httpResponse(url)

    if url.match /^http\:\/\/bit\.ly/
      httpBitlyResponse(url)
    else
      httpResponse(url)