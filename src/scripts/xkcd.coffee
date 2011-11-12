# Grab XKCD comic image urls
#
# xkcd       - The latest XKCD comic
# xkcd <num> - XKCD comic matching the supplied number
#
module.exports = (robot) ->
  robot.respond /xkcd\s?(\d+)?/i, (msg) ->
    if msg.match[1] == undefined
      num = ''
    else
      num = "#{msg.match[1]}/"

    msg.http("http://xkcd.com/#{num}info.0.json")
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send 'Comic not found.'
        else
          object = JSON.parse(body)
          msg.send object.alt
          msg.send object.title
          msg.send object.img
