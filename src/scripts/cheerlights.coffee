#get last color from http://www.cheerlights.com
module.exports = (robot) ->
  robot.respond /cheerlights/i, (msg) ->
   msg.http("http://api.thingspeak.com/channels/1417/field/1/last.json")
    .get() (err, res, body) ->
      response = JSON.parse body
      if response
       msg.send "The last color is: " + response["field1"]
      else
       msg.send "Error"