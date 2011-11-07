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
        responseTitle = response.data.info[0].title
        if responseTitle
          msg.send if response.status_code is 200 then response.data.info[0].title else response.status_txt
        else
          msg.send "This bit.ly link doesn't have a title attribute set."
          #grab longUrl, and retreive using http method

    #else print title
    else
      msg.http(url)
       .get() (err, res, body) ->
	     #try to follow 301 redirects
         if res.statusCode is 301
      	   msg.send "redirect: " + res.headers.location
         else if res.statusCode is 200
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