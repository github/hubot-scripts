# Description:
#   Shorten URLs with bit.ly & expand detected bit.ly URLs
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BITLY_ACCESS_TOKEN
#
# Commands:
#   hubot (bitly|shorten) (me) <url> - Shorten the URL using bit.ly
#   http://bit.ly/[hash] - looks up the real url
#
# Author:
#   sleekslush
#   drdamour
#   johnwyles

module.exports = (robot) ->
  robot.respond /(bitly|shorten)\s?(me)?\s?(.+)$/i, (msg) ->
    msg
      .http("https://api-ssl.bitly.com/v3/shorten")
      .query
        access_token: process.env.HUBOT_BITLY_ACCESS_TOKEN
        longUrl: msg.match[3]
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send if response.status_code is 200 then response.data.url else response.status_txt

   #TODO: can we make this list more expansive/dynamically generated?
   robot.hear /(https?:\/\/(bit\.ly|yhoo\.it|j\.mp|pep\.si|amzn\.to)\/[0-9a-z\-]+)/ig, (msg) ->
    msg
      .http("https://api-ssl.bitly.com/v3/expand")
      .query
        access_token: process.env.HUBOT_BITLY_ACCESS_TOKEN
        shortUrl: msg.match
      .get() (err, res, body) ->
        parsedBody = JSON.parse body
        if parsedBody.status_code is not 200
          msg.send "Lookup failed #{response.status_txt}"
          return

        msg.send "#{m.short_url} is #{m.long_url}" for m in parsedBody.data.expand
