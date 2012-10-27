# Description:
#   Allow Hubot to show what's lurking behind a CloudApp link
#
# Dependencies:
#   None
#
# Configuration:
#   None
# 
# Commands:
#   http://cl.ly/* - Detects the drop's type and displays it or prints its content if it's an image or text file respectively
#
# Author:
#   lmarburger

module.exports = (robot) ->
  robot.hear /(https?:\/\/cl.ly\/image\/[A-Za-z0-9]+)(\/[^\/]+)?/i, (msg) ->
    return if msg.match[2]  # Ignore already embedded images.

    link = msg.match[1]
    msg
      .http(link)
      .headers(Accept: "application/json")
      .get() (err, res, body) ->
        unless res.statusCode is 200
          msg.send "No drop at #{link}! It may have been deleted."
          return

        drop = JSON.parse body
        switch drop.item_type
          when 'image'
            msg.send drop.content_url
          when 'text'
            send_drop_content msg, drop.content_url

send_drop_content = (msg, url) ->
  msg
    .http(url)
    .get() (err, res, body) ->
      if res.statusCode is 302
        # Follow the breadcrumbs of redirects.
        send_drop_content msg, res.headers.location
      else
        body += "\n" unless ~body.indexOf("\n")
        msg.send body
