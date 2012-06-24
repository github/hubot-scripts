# Description:
#   HOLY FUCKING MINDFUCK!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot buscemi me <url> - Adds Steve Buscemi eyes to the specified URL
#   hubot buscemi me <query> - Searches Google Images for the specified query and buscemi's it
#
# Author:
#   dylanegan

module.exports = (robot) ->
  robot.respond /buscemi?(?: me)? (.*)/i, (msg) ->
    buscemi = "http://buscemi.heroku.com?src="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{buscemi}#{imagery}"
    else
      imageMe msg, imagery, (url) ->
        msg.send "#{buscemi}#{url}"

imageMe = (msg, query, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      image  = msg.random images
      cb "#{image.unescapedUrl}#.png"

