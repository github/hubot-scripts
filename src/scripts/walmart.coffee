# Description:
#   Show a random image from peopleofwalmart.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot walmart me - Show random Walmart image
#   hubot mart me - Show random Walmart image
#
# Author:
#   kevinsawicki

module.exports = (robot) ->
  robot.respond /(wal)?mart( me)?/i, (msg) ->
    msg.http("http://www.peopleofwalmart.com/?random=1")
    .get() (error, response) ->
      msg.http(response.headers['location'])
        .get() (err, res, body) ->
          col1 = body.indexOf '<div class="nest">'
          if (col1 != -1)
            body = body.substring col1
            match = body.match /http:\/\/media.peopleofwalmart.com\/wp-content\/uploads\/\d\d\d\d\/\d\d\/.+?\.jpg/g
            if (match) 
              msg.send match[0]
