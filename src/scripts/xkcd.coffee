# Description:
#   Grab XKCD comic image urls
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot xkcd [latest]- The latest XKCD comic
#   hubot xkcd <num> - XKCD comic <num>
#   hubot xkcd random - XKCD comic <num>
#
# Author:
#   twe4ked
#   Hemanth (fixed the max issue)
module.exports = (robot) ->
  robot.respond /xkcd(\s+latest)?$/i, (msg) ->
    msg.http("http://xkcd.com/info.0.json")
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send 'Comic not found.'
        else
          object = JSON.parse(body)
          msg.send object.title, object.img, object.alt

  robot.respond /xkcd\s+(\d+)/i, (msg) ->
    num = "#{msg.match[1]}"

    msg.http("http://xkcd.com/#{num}/info.0.json")
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send 'Comic #{num} not found.'
        else
          object = JSON.parse(body)
          msg.send object.title, object.img, object.alt

  robot.respond /xkcd\s+random/i, (msg) ->
    msg.http("http://xkcd.com/info.0.json")
          .get() (err,res,body) ->
            if res.statusCode == 404
               max = 0
            else
               max = JSON.parse(body).num 
               num = Math.floor((Math.random()*max)+1)
               msg.http("http://xkcd.com/#{num}/info.0.json")
               .get() (err, res, body) ->
                 object = JSON.parse(body)
                 msg.send object.title, object.img, object.alt
