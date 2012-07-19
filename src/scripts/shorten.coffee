# Description:
#   Shorten URLs with bit.ly
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BITLY_USERNAME
#   HUBOT_BITLY_API_KEY
#
# Commands:
#   hubot (bitly|shorten) (me) <url> - Shorten the URL using bit.ly
#
# Author:
#   sleekslush

module.exports = (robot) ->
  robot.respond /(bitly|shorten)\s?(me)?\s?(.+)$/i, (msg) ->
    msg
      .http("http://api.bitly.com/v3/shorten")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        longUrl: msg.match[3]
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send if response.status_code is 200 then response.data.url else response.status_txt
