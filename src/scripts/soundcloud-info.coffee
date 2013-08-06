# Description
#   Show sound information when Soundcloud URLs are seen.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SOUNDCLOUD_CLIENTID: API client_id for SoundCloud
#
# Commands:
#   None
#
# Notes:
#   For text-based adapters like IRC.
#   Set the environment var HUBOT_SOUNDCLOUD_CLIENTID to your SoundCloud API client_id for this to work
#
# Author:
#   Joe Fleming (@w33ble)

module.exports = (robot) ->
  robot.hear /(https?:\/\/(www\.)?soundcloud\.com\/)([\d\w\-\/]+)/i, (msg) ->
    fetchUrl msg, msg.match[0]

fetchUrl = (msg, url) ->
  if not process.env.HUBOT_SOUNDCLOUD_CLIENTID
    return msg.reply "HUBOT_SOUNDCLOUD_CLIENTID must be defined, see http://developers.soundcloud.com/ to get one"

  msg.http("http://api.soundcloud.com/resolve.json?client_id=#{process.env.HUBOT_SOUNDCLOUD_CLIENTID}&url=#{url}")
    .query({
      alt: 'json'
    }).get() (err, res, body) ->
      if res.statusCode is 302
        data = JSON.parse(body)
        showInfo msg, data.location
      else if res.statusCode is 401
        msg.reply "SoundCloud Error: API sent #{res.statusCode}, check your HUBOT_SOUNDCLOUD_CLIENTID setting"
      else
        msg.reply "SoundCloud Error: API resolve returned #{res.statusCode}"

showInfo = (msg, url) ->
  msg.http(url)
    .query({
      alt: 'json'
    }).get() (err, res, body) ->
      if res.statusCode is 200
        data = JSON.parse(body)
        if data.kind in ['playlist', 'track']
          tracks = if data.track_count? then "#{data.track_count} tracks, " else ''
          msg.send "SoundCloud #{data.kind}: #{data.user.username} - #{data.title} (#{tracks}#{getDuration(data.duration)})"
      else
        msg.reply "SoundCloud Error: API lookup returned #{res.statusCode}"

getDuration = (time) ->
  time = time / 1000
  h = time / 60 / 60
  hours = Math.floor h
  m = (h - hours) * 60
  mins = Math.floor m
  secs = Math.round Math.floor((m - mins) * 60)
  if hours > 0
    return "#{hours}h#{mins}m#{secs}s"
  return "#{mins}m#{secs}s"
