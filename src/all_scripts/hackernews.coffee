# Description:
#   Hacker News
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot hn top <N> - get the top N items on hacker news (or your favorite RSS feed)
#   hn.top - refer to the top item on hn
#   hn[i] - refer to the ith item on hn
#
# Author:
#   skimbrel

NodePie = require("nodepie")

hnFeedUrl = "https://news.ycombinator.com/rss"

module.exports = (robot) ->
  robot.respond /HN top (\d+)?/i, (msg) ->
    msg.http(hnFeedUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Something's gone awry"
      else
        feed = new NodePie(body)
        try
          feed.init()
          count = msg.match[1] || 5
          items = feed.getItems(0, count)
          msg.send item.getTitle() + ": " + item.getPermalink() + " (" + item.getComments()?.html + ")" for item in items
        catch e
          console.log(e)
          msg.send "Something's gone awry"

  robot.hear /HN(\.top|\[\d+\])/i, (msg) ->
     msg.http(hnFeedUrl).get() (err, res, body) ->
       if res.statusCode is not 200
         msg.send "Something's gone awry"
       else
         feed = new NodePie(body)
         try
           feed.init()
         catch e
           console.log(e)
           msg.send "Something's gone awry"
         element = msg.match[1]
         if element == "HN.top"
           idx = 0
         else
           idx = (Number) msg.match[0].replace(/[^0-9]/g, '')
         try
           item = feed.getItems()[idx]
           msg.send item.getTitle() + ": " + item.getPermalink() + " (" + item.getComments()?.html + ")"
         catch e
           console.log(e)
           msg.send "Something's gone awry"
