# Description:
#   party_gifs.coffee - Make a GIF on the fly from search terms.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot gif me <query> - Create a gif using images from the web.
#   hubot pty me <query> - Alias for 'gif'.
#
# Notes:
#   GIFs created by the gifs.pty.io API.
#   Images come from the Google Image API.
#
# Author:
#   dzello

module.exports = (robot) ->
  robot.respond /(gif|pty)( me)? (.*)/i, (msg) ->
    gifMe(msg, msg.match[3])

gifMe = (msg, query) ->
  url = "http://gifs.pty.io/#{encodeURIComponent(query)}.gif"
  msg.http(url)
    .head() (err, res, body) ->
      if res.statusCode == 404
        msg.send "Couldn't find any images."
      else if err or res.statusCode > 404
        msg.send "An error occurred creating that GIF."
      else
        msg.send url

