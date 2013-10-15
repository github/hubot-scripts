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
      video_hash = query_parsed.v
      showInfo msg, video_hash

  robot.hear /(https?:\/\/youtu\.be\/)([a-z0-9\-_]+)/i, (msg) ->
    video_hash = msg.match[2]
    showInfo msg, video_hash

showInfo = (msg, video_hash) ->
  msg.http("http://gdata.youtube.com/feeds/api/videos/#{video_hash}")
    .query({
      alt: 'json'
    }).get() (err, res, body) ->
      if res.statusCode is 200
        data = JSON.parse(body)
        entry = data.entry
        msg.send "YouTube: #{entry.title.$t} (#{formatTime(entry.media$group.yt$duration.seconds)})"
      else
        msg.send "YouTube: error: #{video_hash} returned #{res.statusCode}: #{body}"

formatTime = (seconds) ->
  min = Math.floor(seconds / 60)
  sec = seconds % 60

  result = ''
  if (min > 0)
    result += "#{min}m"
  if (sec > 0)
    result += "#{sec}s"

  result
