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
{inspect} = require('util')

vanityAccount = process.env.HUBOT_VANITY_TWITTER_ACCOUNT

module.exports = (robot) ->
  countFollowers = (msg, ids, callback) ->
    counts = []
    total = ids.length

    while (slice = ids.splice(0,99)).length
      robot.twitter.lookupUsers slice, (err, users) ->
        if err
          msg.send "Encountered a problem lookup up friends", inspect err
          return
        users.forEach (user) ->
          keptUser =
            followers: user.followers_count
            screen_name: user.screen_name

          counts.push keptUser
          # if last user
          if counts.length == (total-1)
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
            callback response

  robot.respond /vanity me$/i, (msg) ->
    unless vanityAccount
      msg.send "No HUBOT_VANITY_TWITTER_ACCOUNT set :("
      return

    unless robot.twitter
      msg.send "Couldn't connect to twitter :("
      return

    robot.twitter.getFriendsIds vanityAccount, (err, data) ->
        if err
          msg.send "Encountered a problem getting #{vanityAccount}'s friends", inspect err
          return

        countFollowers msg, data, (output) ->
          msg.send output
