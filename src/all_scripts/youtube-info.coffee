# Description
#   Show video metadata when YouTube URLs are seen.
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

querystring = require 'querystring'
url = require 'url'

module.exports = (robot) ->
  robot.hear /(https?:\/\/www\.youtube\.com\/watch\?.+?)(?:\s|$)/i, (msg) ->
    url_parsed = url.parse(msg.match[1])
    query_parsed = querystring.parse(url_parsed.query)

    if query_parsed.v
      api_url = "http://gdata.youtube.com/feeds/api/videos/#{query_parsed.v}"
      msg.http(api_url)
        .query({
          alt: 'json'
        }).get() (err, res, body) ->
          if res.statusCode is 200
            data = JSON.parse(body)
            entry = data.entry
            msg.send "YouTube: #{entry.title.$t} (#{formatTime(entry.media$group.yt$duration.seconds)})"
          else
            msg.send "YouTube: error: #{api_url} returned #{res.statusCode}: #{body}"

formatTime = (seconds) ->
  min = Math.floor(seconds / 60)
  sec = seconds % 60

  result = ''
  if (min > 0)
    result += "#{min}m"
  if (sec > 0)
    result += "#{sec}s"

  result
