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
    msg.http('http://www.loc.gov/pictures/search/?fo=json&q=' + q )
      .get() (err, res, body) ->
        response = JSON.parse(body)
        images = response.results
        if images.length > 0
          image  = msg.random images
          image  = msg.random images while (/500x500_TGM/.test(image.image.full) or /500x500_look/.test(image.image.full) or /500x500_grouprecord/.test(image.image.full) or /500x500_notdigitized/.test(image.image.full))
          msg.send image.image.full
