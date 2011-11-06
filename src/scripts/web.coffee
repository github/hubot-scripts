# Webutility
#
# returns title of urls

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.hear /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/i, (msg) ->
    url = msg.match[0]
    msg.http(url)
     .get() (err, res, body) ->
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
           msg.send "No title found. Time to unleash the nerds/jackels."