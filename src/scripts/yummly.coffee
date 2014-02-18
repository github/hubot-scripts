# Description:
#   Get a meal from Yummly
#
# Configuration:
#   HUBOT_YUMMLY_APP_KEY
#   HUBOT_YUMMLY_APP_ID
#
# Commands:
#   hubot I'm hungry for <food>
#   
#



app_id = process.env.HUBOT_YUMMLY_APP_ID
app_key = process.env.HUBOT_YUMMLY_APP_KEY

module.exports = (robot) ->
  robot.hear /I'm hungry for (.*)/i, (msg) ->
    robot.http("http://api.yummly.com/v1/api/recipes?_app_id=#{app_id}&_app_key=#{app_key}&maxResult=5&q=" + msg.match[1])
    .get() (err, res, body) ->
      console.log body
      console.log err
      yd = JSON.parse(body)
      item = msg.random yd.matches
      name = item.recipeName
      id = item.id
      msg.send  msg.message.user.name + ": how about " + name
      msg.send "http://www.yummly.com/recipe/" + id
      return
