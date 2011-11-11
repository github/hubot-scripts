# Show a random image from peopleofwalmart.com
#
# walmart me - Show random Walmart image
# mart me - Show random Walmart image
#     
module.exports = (robot) ->
  robot.respond /(wal)?mart( me)?/i, (msg) ->
    random = Math.floor(Math.random() * 770)
    msg.http("http://www.peopleofwalmart.com/photos/random-photos/page/" + random)
    .get() (err, res, body) ->
      col1 = body.indexOf '<div class="column_one">'
      if (col1 != -1)
        body = body.substring col1
        match = body.match /http:\/\/media.peopleofwalmart.com\/wp-content\/uploads\/\d\d\d\d\/\d\d\/.+?\.jpg/g
        if (match) 
          msg.send match[0]
