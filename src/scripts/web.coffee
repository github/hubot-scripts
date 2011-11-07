# Webutility
#
# returns title of urls

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.hear /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/i, (msg) ->
    url = msg.match[0]
    #if url matches bitly
    if url.match /^http\:\/\/bit\.ly/
      msg.http("http://api.bitly.com/v3/info")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        shortUrl: url
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        console.log response.data.info[0].title
        msg.send if response.status_code is 200 then response.data.info[0].title else response.status_txt


    #else print title
    else
      msg.http(url)
       .get() (err, res, body) ->
         if res.statusCode is 200 or 301
           handler = new HtmlParser.DefaultHandler()
           parser  = new HtmlParser.Parser handler
           parser.parseComplete body
           results = (Select handler.dom, "head title")
           if results[0]
             msg.send results[0].children[0].raw
           else
             results = (Select handler.dom, "title")
             if results[0]
               console.log results[0]
               msg.send results[0].children[0].raw
         else
           msg.send res.statusCode