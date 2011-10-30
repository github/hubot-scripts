# Shorten URLs with bit.ly
#
# (bitly|shorten) me <url> - Shorten the URL using bit.ly

module.exports = (robot) ->
  robot.respond /(bitly|shorten) me (.+)$/, (msg) ->
    msg
      .http("http://api.bitly.com/v3/shorten")
      .query
        login: process.env.HUBOT_BITLY_USERNAME
        apiKey: process.env.HUBOT_BITLY_API_KEY
        longUrl: msg.match[2]
        format: "json"
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send if response.status_code is 200 then response.data.url else response.status_txt
