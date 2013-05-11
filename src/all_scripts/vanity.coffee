# Description:
#   Race to the bottom.
#
#   Battle it out with your mates to see who is the
#   most important/coolest/sexiest/funniest/smartest of them all solely
#   based on the clearly scientific number of twitter followers.
#
#   Vanity will check all the users that a specific twitter account, like say maybe
#   your company's twitter account, follows and display them in order by followers.
#
# Dependencies:
#   "sprintf": "0.1.1"
#
# Configuration:
#   HUBOT_VANITY_TWITTER_ACCOUNT
#
# Commands:
#   hubot vanity me - list peeps ordered by twitter followers
#
# Author:
#   maddox

Path     = require "path"
sprintf  = require("sprintf").sprintf

countFollowers = (msg, ids, cb) ->
  counts = []

  ids.forEach (id) ->
    console.log id
    msg.http("http://api.twitter.com/1/users/show.json?user_id=#{id}")
      .get() (err, res, body) ->
        user = JSON.parse body

        keptUser =
          followers: user.followers_count
          screen_name: user.screen_name

        console.log keptUser
        counts.push keptUser
        if counts.length == ids.length
          last     = 0
          response = ""
          counts.sort (x, y) ->
            y.followers - x.followers
          counts.forEach (user) ->
            if last > 0
              diff = last - user.followers
              response += sprintf("%15s : %5d ( %4d to go)\n", user.screen_name, user.followers, diff)
            else
              response += sprintf("%15s : %5d\n", user.screen_name, user.followers)
            last = user.followers
          cb response

module.exports = (robot) ->
  robot.respond /vanity me$/i, (msg) ->
    msg.http("http://api.twitter.com/1/friends/ids.json?screen_name=" + process.env.HUBOT_VANITY_TWITTER_ACCOUNT)
      .get() (err, res, body) ->
        if res.statusCode == 200
          countFollowers msg, JSON.parse(body), (output) ->
            msg.send output
        else
          msg.reply "Sorry, not right now. Twitter's returning a #{res.statusCode} error"
