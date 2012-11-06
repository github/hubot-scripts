# Description
#   Show image metadata when imgur URLs are seen.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#   For text-based adapters like IRC.
#
# Author:
#   mmb

module.exports = (robot) ->
  robot.hear /http:\/\/(?:i\.)?imgur\.com\/(?:gallery\/)?([a-z\d]+)(?:\.(?:gif|jpe?g|png))?/i, (msg) ->
    api_url = "http://imgur.com/gallery/#{msg.match[1]}.json"
    msg.http(api_url).get() (err, res, body) ->
      if res.statusCode is 200
        data = JSON.parse(body)
        msg.send "imgur: #{data.data.image.title}"
      else
        console.error "imgur-info script error: #{api_url} returned #{res.statusCode}: #{body}"
