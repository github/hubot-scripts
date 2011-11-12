# Grab a Punchform recipe - http://punchfork.com/api
#
# Punchfork         - Instantly browse the best new recipes from top food sites in one place.
# cook <ingredent>  - Suggest recipe based on ingredent
#
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
