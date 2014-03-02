# Description:
#   Messing around with the Instagram API.
#
# Dependencies:
#   "underscore": "1.6.0"
#
# Configuration:
#   HUBOT_INSTAGRAM_CLIENT_ID (http://instagram.com/developer/clients/manage/)
#		
# Commands:
#   hubot instagram popular.
#   hubot instagram user <query>.

# Author:
#   Dongri Jin

INSTAGRAM_API = "https://api.instagram.com/v1"
INSTAGRAM_CLIENT = "client_id=#{process.env.HUBOT_INSTAGRAM_CLIENT_ID}"

_ = require 'underscore'
module.exports = (robot) ->
  robot.respond /(instagram|insta) popular/i, (msg) ->
    robot.http("#{INSTAGRAM_API}/media/popular?#{INSTAGRAM_CLIENT}")
      .query({})
      .get() (err, res, body) ->
        json = JSON.parse(body)
        data = json.data
        data = _.shuffle(data)
        data = data.slice(0, 1)
        data.forEach (d) ->
          msg.send d.images.low_resolution.url

  robot.respond /(instagram|insta) user (.*)/i, (msg) ->
    username = msg.match[2]
    robot.http("#{INSTAGRAM_API}/users/search?#{INSTAGRAM_CLIENT}")
      .query({q:username})
      .get() (err, res, body) ->
        json = JSON.parse(body)
        data = json.data
        if data.length > 0
          d = data[0]
          id = d.id
          robot.http("#{INSTAGRAM_API}/users/#{id}/media/recent?#{INSTAGRAM_CLIENT}")
            .query({})
            .get() (err, res, body) ->
              json = JSON.parse(body)
              if json.meta.code is 200
                data = json.data
                data = _.shuffle(data)
                data = data.slice(0, 1)
                data.forEach (d) ->
                  msg.send d.images.low_resolution.url
              else
                msg.send "No results for \"#{username}\""
        else
          msg.send "No results for \"#{username}\""
