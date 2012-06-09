# Description:
#   Grab a Punchform recipe - http://punchfork.com/api
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PUNCHFORK_APIKEY
#
# Commands:
#   hubot cook <ingredent>  - Suggest recipe based on ingredent
#
# Author:
#   adamstrawson

module.exports = (robot) ->
  robot.respond /cook (.*)$/i, (msg) ->
 
    keyword = "#{msg.match[1]}/"
      
    api_key = process.env.HUBOT_PUNCHFORK_APIKEY

    msg.http("http://api.punchfork.com/recipes?key=#{api_key}&q=#{keyword}&count=1")
      .get() (err, res, body) ->
        if res.statusCode == 404
          msg.send 'No recipe not found.'
        else
          object = JSON.parse(body)
          msg.send object.recipes[0].title
          msg.send object.recipes[0].pf_url
