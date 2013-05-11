# Description:
#   Loads images from Dribbble URL's
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot (depress|dribbble|inspire) me - brings up popular images
#   [dribbble URL] - brings up image from the URL
#
# Author:
#   mattgraham

requestImage = (msg, url) ->
  msg.http(url).get() (err, res, body) ->
    if res.statusCode == 302 && res.headers.location
      requestImage msg, res.headers.location
    
    else
      data = JSON.parse(body)
      msg.send data.image_url
      msg.send '"' + data.title + '"' + " by " + data.player.name

module.exports = (robot) ->
  robot.respond /(depress|dribbble|inspire)( me)? (.*)/i, (msg) ->
    query = msg.match[4]
    query ||= 'popular'
    msg.http("http://api.dribbble.com/shots/#{query}")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        idx = Math.floor(Math.random() * (data.shots.length - 2))
        for i in [0..2]
          msg.send data.shots[idx + i].image_url
  
  robot.hear /^https?:\/\/((www\.)?dribbble\.com\/shots\/?([0-9]+))|(drbl\.in\/([a-zA-Z0-9]+))/, (msg) ->
    query = msg.match[3] || msg.match[5]
    requestImage msg, "http://api.dribbble.com/shots/#{query}"
