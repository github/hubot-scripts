# Description:
#   Hubot searches the Library of Congress image archives
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot locpix me <query> - Search the Library of Congress image archives
#
# Author:
#   pj4533

module.exports = (robot) ->
  robot.respond /locpix?(?: me)? (.*)/i, (msg) ->
    q = escape(msg.match[1])
    msg.http('http://www.loc.gov/pictures/search/?fo=json&fa=displayed:anywhere&q=' + q )
      .get() (err, res, body) ->
        response = JSON.parse(body)
        images = response.results
        if images.length > 0
          image  = msg.random images
          msg.send image.image.full
