# Description
#   Show video metadata when YouTube URLs are seen.
#
# Dependencies:
#   None
#
# Configuration:
#   apiKey - You will want to get an API key from https://console.developers.google.com/ to avoid being locked out from too many requests
#
# Commands:
#   [YouTube video URL] - shows title and time length for the URL
#
# Notes:
#   For text-based adapters like IRC.
#
# Author:
#   mmb
#   Updated to YouTube API v3 by Serneum

querystring = require 'querystring'
url = require 'url'
apiKey = <INSERT KEY HERE>

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
  msg.http("https://www.googleapis.com/youtube/v3/videos?part=id,snippet,contentDetails,statistics&id=#{video_hash}&key=#{apiKey}")
    .query({
      alt: 'json'
    }).get() (err, res, body) ->
      if res.statusCode is 200
        data = JSON.parse(body)
        title = data.items[0].title
        views = humanizeNumber(data.statistics.viewCount)
        thumbs_up = humanizeNumber(data.statistics.likeCount)
        thumbs_down = humanizeNumber(data.statistics.dislikeCount)
        time = formatTime(data.contentDetails.duration)
        thumbs_up = Math.round(((r.average-r.min)/(r.max-r.min))*r.numRaters)
        thumbs_down = r.numRaters - thumbs_up
        msg.send "YouTube: #{title} (#{time}, #{views} views, #{thumbs_up} thumbs up, #{thumbs_down} thumbs down)"
      else
        msg.send "YouTube: error: #{video_hash} returned #{res.statusCode}: #{body}"

formatTime = (duration) ->
  pattern = /PT(\d+H)?(\d+M)?(\d+S)?/g
  [hours, min, sec] = duration.match(pattern)[1..3]

  result = ''
  if (!!hours)
    result += "#{hours.slice(0, -1)}h"
  if (!!min)
    result += "#{min.slice(0, -1)}m"
  if (!!sec)
    result += "#{sec.slice(0, -1)}s"

  result

humanizeNumber = (n) ->
  n = n.toString()
  while true
    n2 = n.replace(/(\d)(\d{3})($|,)/g, '$1,$2$3')
    break if n == n2
    n = n2
  n
