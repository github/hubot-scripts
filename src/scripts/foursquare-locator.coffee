# Description:
#   Get last checkin of your bot's friends
#
# Dependencies:
#   "node-foursquare": "0.2.0"
#
# Configuration:
#   FOURSQUARE_CLIENT_ID
#   FOURSQUARE_CLIENT_SECRET
#   FOURSQUARE_ACCESS_TOKEN
#
# Commands:
#   hubot foursquare approve - Approves the bot user's pending friend requests
#   hubot foursquare friends - Lists the friends of the bot
#   hubot foursquare register - Tells how to friend the bot
#   where is __? - Filters recent checkins to a particular subset of users.
#
# Notes:
#   To obtain/set the FOURSQUARE_ACCESS_TOKEN, you will need to go through the OAuth handshake manually with your bot's credentials
#
# Authors:
#   stephenyeargin, jfryman, brandonvalentine

Util = require "util"
moment = require "moment"

module.exports = (robot) ->

  config = secrets:
    clientId: process.env.FOURSQUARE_CLIENT_ID
    clientSecret: process.env.FOURSQUARE_CLIENT_SECRET
    accessToken: process.env.FOURSQUARE_ACCESS_TOKEN
    redirectUrl: "localhost"

  foursquare = require('node-foursquare')(config);

  # Who are my friends?
  robot.respond /foursquare friends/i, (msg) ->
    params = {}
    foursquare.Users.getFriends 'self', params, config.secrets.accessToken, (error, response) ->

      # Loop through friends
      if response.friends.items.length > 0
        list = []
        for own key, friend of response.friends.items
          user_name = formatName friend
          list.push user_name

        msg.send list.join(", ")
      else
        msg.send "Your bot has no friends. :("

  # Approve pending bot friend quests
  robot.respond /foursquare approve/i, (msg) ->
    foursquare.Users.getRequests config.secrets.accessToken, (error, response) ->

      # Loop through requests
      if response.requests.length > 0

        for own key, friend of response.requests
          msg.http("https://api.foursquare.com/v2/users/#{friend.id}/approve?oauth_token=#{config.secrets.accessToken}").post() (err, res, body) ->
            user_name = formatName friend
            msg.send "Approved: #{user_name}"
  
      # Your bot is lonely
      else
        msg.send "No friend requests to approve."

  # Tell people how to friend the bot
  robot.respond /foursquare register/i, (msg) ->
    foursquare.Users.getUser 'self', config.secrets.accessToken, (error, response) ->
      profile_url = "https://foursquare.com/user/#{response.user.id}"
      user_name = response.user
      msg.send "Head to #{profile_url} and friend #{user_name}!"
      msg.send response.user.bio if response.user.bio?

  # Find your friends
  robot.hear /where[ ']i?s ([a-zA-Z0-9 ]+)(\?)?/i, (msg) ->
    searchterm = msg.match[1].toLowerCase()

    params =
      limit: 100

    foursquare.Checkins.getRecentCheckins params, config.secrets.accessToken, (error, response) ->

      # Loop through friends
      found = 0
      for own key, checkin of response.recent

        # Skip if no string match
        user_name = formatName checkin.user
        user_name = user_name.toLowerCase()
        if ~user_name.indexOf searchterm
          timeFormatted = moment(new Date(checkin.createdAt*1000)).fromNow()
          msg.send "#{checkin.user.firstName} #{checkin.user.lastName} was at #{checkin.venue.name} #{timeFormatted}"
          found++

      # If loop failed to come up with a result, tell them
      if found is 0
        msg.send "Could not find a recent checkin from #{searchterm}."

  # Format a name string
  formatName = (user) ->
    if user.lastName?
      return "#{user.firstName} #{user.lastName}"
    else if user.firstName?
      return user.firstName
    else
      return "(No Name)"
