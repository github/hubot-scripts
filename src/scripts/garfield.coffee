# Description:
#   For the love of Garfield
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   garfield - get the latest Garfield comic
#   garfield random - get a randomized Garfield comic

module.exports = (robot) ->

  robot.respond /garfield/i, (msg) ->
    if msg.message.text is "hubot garfield"
      msg.http("http://garfield.com/")
        .get() (err, res, body) ->
          image = body.match(/style="margin: 0 auto;" src="(.*)" width="900"/)
          msg.send image[1]

  robot.respond /garfield random/i, (msg) ->
    msg.http("http://garfield.com/comic/random")
      .get() (err, res, body) ->
        random_url = body.match(/Redirecting to (.*)\<\/title\>/)
        msg.http(random_url[1])
          .get() (err2, res2, body2) ->
            image = body2.match(/"img-responsive center-block" src="(.*)" width="900"/)
            msg.send image[1]