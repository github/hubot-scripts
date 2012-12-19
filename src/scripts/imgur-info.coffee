# Description
#   Show image metadata when imgur URLs are seen.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_IMGUR_CLIENTID - your client id from imgur
#
# Commands:
#   None
#
# Notes:
#   For text-based adapters like IRC.
#   You'll need to generate a Client-ID at:
#       https://api.imgur.com/oauth2/addclient
#
# Author:
#   mmb

token = "Client-ID #{process.env.HUBOT_IMGUR_CLIENTID}"

module.exports = (robot) ->
  robot.hear /(?:http:\/\/)?(?:i\.)?imgur\.com\/(a\/)?(\w+)(?:\.(?:gif|jpe?g|png))?/i, (msg) ->
    type = if msg.match[1]? then 'gallery' else 'image'
    api_url = "https://api.imgur.com/3/#{type}/#{msg.match[2]}/"
    msg.http(api_url).headers('Authorization': token).get() (err, res, body) ->
      if res.statusCode is 200
        data = JSON.parse(body)
        msg.send "imgur: #{data.data.title}"
      else
        console.error "imgur-info script error: #{api_url} returned #{res.statusCode}: #{body}"
