# Description:
#   Integrates with memegenerator.net
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_MEMEGEN_USERNAME
#   HUBOT_MEMEGEN_PASSWORD
#   HUBOT_MEMEGEN_DIMENSIONS
#
# Commands:
#   hubot Y U NO <text>  - Generates the Y U NO GUY with the bottom caption of <text>
#   hubot I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#   hubot <text> ORLY? - Generates the ORLY? owl with the top caption of <text>
#   hubot <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#   hubot <text> ALL the <things> - Generates ALL THE THINGS
#   hubot <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#   hubot good news everyone! <news> - Generates Professor Farnsworth
#   hubot khanify <text> - TEEEEEEEEEEEEEEEEEXT!
#   hubot Not sure if <text> or <text> - Generates Futurama Fry
#   hubot Yo dawg <text> so <text> - Generates Yo Dawg
#   hubot ALL YOUR <text> ARE BELONG TO US - Generates Zero Wing with the caption of <text>
#   hubot if <text>, <word that can start a question> <text>? - Generates Philosoraptor
#   hubot <text> FUCK YOU - Angry Linus
#   hubot (Oh|You) <text> (Please|Tell) <text> - Willy Wonka
#   hubot <text> you're gonna have a bad time - Bad Time Ski Instructor
#   hubot one does not simply <text> - Lord of the Rings Boromir
#
# Author:
#   skalnik

module.exports = (robot) ->
  robot.respond /Y U NO (.+)/i, (msg) ->
    caption = msg.match[1] || ""

    memeGenerator msg, 2, 166088, "Y U NO", caption, (url) ->
      msg.send url

  robot.respond /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, (msg) ->
    memeGenerator msg, 74, 2485, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(O\s?RLY\??.*)/i, (msg) ->
    memeGenerator msg, 920, 117049, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(SUCCESS|NAILED IT.*)/i, (msg) ->
    memeGenerator msg, 121, 1031, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (ALL the .*)/i, (msg) ->
    memeGenerator msg, 6013, 1121885, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (\w+\sTOO DAMN .*)/i, (msg) ->
    memeGenerator msg, 998, 203665, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(GOOD NEWS EVERYONE[,.!]?) (.*)/i, (msg) ->
    memeGenerator msg, 1591, 112464, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /k(?:ha|ah)nify (.*)/i, (msg) ->
    memeGenerator msg, 6443, 1123022, "", khanify(msg.match[1]), (url) ->
      msg.send url
      
  robot.respond /(NOT SURE IF .*) (OR .*)/i, (msg) ->
    memeGenerator msg, 305, 84688, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(YO DAWG .*) (SO .*)/i, (msg) ->
    memeGenerator msg, 79, 108785, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(ALL YOUR .*) (ARE BELONG TO US)/i, (msg) ->
    memeGenerator msg, 349058, 2079825, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(IF .*), ((ARE|CAN|DO|DOES|HOW|IS|MAY|MIGHT|SHOULD|THEN|WHAT|WHEN|WHERE|WHICH|WHO|WHY|WILL|WON\'T|WOULD)[ \'N].*)/i, (msg) ->
    memeGenerator msg, 17, 984, msg.match[1], msg.match[2] + (if msg.match[2].search(/\?$/)==(-1) then '?' else ''), (url) ->
      msg.send url

  robot.respond /(.*) FUCK YOU/i, (msg) ->
    memeGenerator msg, 1189472, 5044147, msg.match[1], 'FUCK YOU', (url) ->
      msg.send url

  robot.respond /((Oh|You) .*) ((Please|Tell) .*)/i, (msg) ->
    memeGenerator msg, 542616, 2729805, msg.match[1], msg.match[3], (url) ->
      msg.send url

  robot.respond /(.*) (You'?re gonna have a bad time)/i, (msg) ->
    memeGenerator msg, 825296, 3786537, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(one does not simply) (.*)/i, (msg) ->
    memeGenerator msg, 274947, 1865027, msg.match[1], msg.match[2], (url) ->
      msg.send url

memeGenerator = (msg, generatorID, imageID, text0, text1, callback) ->
  username = process.env.HUBOT_MEMEGEN_USERNAME
  password = process.env.HUBOT_MEMEGEN_PASSWORD
  preferredDimensions = process.env.HUBOT_MEMEGEN_DIMENSIONS

  unless username? and password?
    msg.send "MemeGenerator account isn't setup. Sign up at http://memegenerator.net"
    msg.send "Then ensure the HUBOT_MEMEGEN_USERNAME and HUBOT_MEMEGEN_PASSWORD environment variables are set"
    return

  msg.http('http://version1.api.memegenerator.net/Instance_Create')
    .query
      username: username,
      password: password,
      languageCode: 'en',
      generatorID: generatorID,
      imageID: imageID,
      text0: text0,
      text1: text1
    .get() (err, res, body) ->
      result = JSON.parse(body)['result']
      if result? and result['instanceUrl']? and result['instanceImageUrl']? and result['instanceID']?
        instanceID = result['instanceID']
        instanceURL = result['instanceUrl']
        img = result['instanceImageUrl']
        msg.http(instanceURL).get() (err, res, body) ->
          # Need to hit instanceURL so that image gets generated
          if preferredDimensions?
            callback "http://images.memegenerator.net/instances/#{preferredDimensions}/#{instanceID}.jpg"
          else
            callback "http://images.memegenerator.net/instances/#{instanceID}.jpg"
      else
        msg.reply "Sorry, I couldn't generate that image."

khanify = (msg) ->
  msg = msg.toUpperCase()
  vowels = [ 'A', 'E', 'I', 'O', 'U' ]
  index = -1
  for v in vowels when msg.lastIndexOf(v) > index
    index = msg.lastIndexOf(v)
  "#{msg.slice 0, index}#{Array(10).join msg.charAt(index)}#{msg.slice index}!!!!!"
