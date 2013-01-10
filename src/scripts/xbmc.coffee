# Description:
#   Plays YouTube videos on XBMC
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_XBMC_URL
#   HUBOT_XBMC_USER
#   HUBOT_XBMC_PASSWORD
#
# Commands:
#   hubot xbmc <youtube url> - Plays the video at <youtube url>
#   hubot where is xbmc? - Displays HUBOT_XBMC_URL
#
# Notes:
#   Requirements:
#   * XBMC with the YouTube plugin v3.1.0 or greater installed.
#   * Allow remote control of your XBMC via HTTP.
#   
#   Tested with XBMC Eden. Should work with versions that have the JSON-RPC API.
#
# Author:
#   lucaswilric
#

http = require 'http'
url = require 'url' 

xbmcUri = process.env.HUBOT_XBMC_URL
xbmcUser = process.env.HUBOT_XBMC_USER
xbmcPassword = process.env.HUBOT_XBMC_PASSWORD || ''

playYouTube = (videoId, msg) ->
  xbmcRequest "Player.Open", {"item":{"file":"plugin://plugin.video.youtube/?action=play_video&videoid=" + videoId }}, msg

xbmcStop = (msg) ->
  xbmcRequest "Player.Stop", {"playerid": 1}, msg

xbmcRequest = (method, params, msg) ->
  unless xbmcUri?
    msg.reply "I don't know where XBMC is. Please configure a URL."
    return
    
  unless xbmcUser?
    msg.reply "I don't have a user name to give XBMC. Please configure one."
    return

  data = JSON.stringify({"jsonrpc": "2.0", "method": method, "params": params, "id": 1})
  req = msg.http(xbmcUri + 'jsonrpc').auth(xbmcUser, xbmcPassword)
  
  req.post(data) (err, res, body) ->
      if res.statusCode == 401
        msg.send "XBMC is saying I'm unauthorised. Check my credentials, would you?" 
      if res.statusCode == 200
        msg.reply "Done."
  
  
getYouTubeVideoIdFrom = (videoUrl) ->
  uri = url.parse((if /^http/.test videoUrl then videoUrl else 'http://'+videoUrl), true)
  if /youtube.com$/.test uri.host
    return uri.query.v if uri.query? and uri.query.v?
    return uri.path.match(/\/v\/([^\/]*)/) if /\/v\//.test uri.path
  if /^youtu.be$/.test uri.host
    return uri.path.replace '/', ''


module.exports = (robot) ->  
  robot.respond /xbmc (\S*youtu\.?be\S*)/i, (msg) ->
    if /(^|\/\/)((www.)?(youtube.com)|youtu.be)\//.test msg.match[1]
      videoId = getYouTubeVideoIdFrom msg.match[1]
      if videoId?
        playYouTube videoId, msg
        return
    msg.reply "That doesn't look like something I can tell XBMC to play. Sorry :("
  
  robot.respond /xbmc stop/i, (msg) ->
    xbmcStop(msg)
  
  robot.respond /where('s| is) xbmc\??/i, (msg) ->
    msg.send 'XBMC is at ' + process.env.HUBOT_XBMC_URL