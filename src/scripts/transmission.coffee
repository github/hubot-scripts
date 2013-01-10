#
# Description:
#   Gets a list of active torrents from  Transmission, a BitTorrent client.
# 
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TRANSMISSION_USER - Transmission HTTP username
#   HUBOT_TRANSMISSION_PASSWORD - Transmission HTTP password
#   HUBOT_TRANSMISSION_URL - The URL used to access Transmission remotely
#
# Commands:
#   hubot torrents - Get a list of open torrents
#   hubot where is transmission? - Reply with the URL Hubot is using to talk to Transmission
#
# Notes:
#   This script uses Transmission's HTTP interface to get the information for its 
#   responses. To enable remote access to Transmission and get the values for the 
#   settings, you can follow the Transmission documentation at 
#   https://trac.transmissionbt.com/wiki/UserDocumentation
#   There should be a section about remote access under the section for your chosen OS.
# 
# Author:
#   lucaswilric

url = process.env.HUBOT_TRANSMISSION_URL
user = process.env.HUBOT_TRANSMISSION_USER
password = process.env.HUBOT_TRANSMISSION_PASSWORD || ''

getTorrents = (msg, sessionId = '', recursions = 0) ->
  return if recursions > 4
  
  unless url?
    msg.reply "I don't know where Transmission is. Please configure a URL."
    return
  
  unless user?
    msg.reply "I don't have a user name to give Transmission. Please configure one."
    return
  
  msg.http(url)
    .auth(user, password)
    .header('X-Transmission-Session-Id', sessionId)
    .post(JSON.stringify({method: "torrent-get", arguments: { fields: ["id", "name", "downloadDir", "percentDone", "files", "isFinished"]}})) (err, res, body) ->
      if res.statusCode == 409
        getTorrents(msg, res.headers['x-transmission-session-id'], recursions + 1)
      else
        response = ''
        torrents = JSON.parse(body).arguments.torrents
        if torrents.length == 0
          msg.send "There aren't any torrents loaded right now."
          return
        response += "\n[#{100 * t.percentDone}%] #{t.name}" for t in torrents
        msg.send response

module.exports = (robot) ->
  robot.respond /torrents/i, (msg) ->
    getTorrents(msg)
    
  robot.respond /where('s| is) transmission\??/i, (msg) ->
    msg.send "Transmission is at " + url
