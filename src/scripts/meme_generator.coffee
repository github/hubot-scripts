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
  unless robot.brain.data.memes?
    robot.brain.data.memes = [
      {
        regex: /(Y U NO) (.+)/i,
        generatorID: 2,
        imageID: 166088
      },
      {
        regex: /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i,
        generatorID: 74,
        imageID: 2485
      },
      {
        regex: /(.*)(O\s?RLY\??.*)/i,
        generatorID: 920,
        imageID: 117049
      },
      {
        regex: /(.*)(SUCCESS|NAILED IT.*)/i,
        generatorID: 121,
        imageID: 1031
      },
      {
        regex: /(.*) (ALL the .*)/i,
        generatorID: 6013,
        imageID: 1121885
      },
      {
        regex: /(.*) (\w+\sTOO DAMN .*)/i,
        generatorID: 998,
        imageID: 203665
      },
      {
        regex: /(GOOD NEWS EVERYONE[,.!]?) (.*)/i,
        generatorID: 1591,
        imageID: 112464
      },
      {
        regex: /(NOT SURE IF .*) (OR .*)/i,
        generatorID: 305,
        imageID: 84688
      },
      {
        regex: /(YO DAWG .*) (SO .*)/i,
        generatorID: 79,
        imageID: 108785
      },
      {
        regex: /(ALL YOUR .*) (ARE BELONG TO US)/i,
        generatorID: 349058,
        imageID: 2079825
      },
      {
        regex: /(.*) (FUCK YOU)/i,
        generatorID: 1189472,
        imageID: 5044147
      },
      {
        regex: /(.*) (You'?re gonna have a bad time)/i,
        generatorID: 825296,
        imageID: 3786537
      },
      {
        regex: /(one does not simply) (.*)/i,
        generatorID: 274947,
        imageID: 1865027
      },
      {
        regex: /(grumpy cat) (.*),(.*)/i,
        generatorID: 1590955,
        imageID: 6541210
      }
    ]

  for meme in robot.brain.data.memes
    memeResponder robot, meme

  robot.respond /add meme \/(.+)\/i,(.+),(.+)/i, (msg) ->
    meme =
      regex: new RegExp(msg.match[1], "i")
      generatorID: parseInt(msg.match[2])
      imageID: parseInt(msg.match[3])

    robot.brain.data.memes.push meme
    memeResponder robot, meme

  robot.respond /k(?:ha|ah)nify (.*)/i, (msg) ->
    memeGenerator msg, 6443, 1123022, "", khanify(msg.match[1]), (url) ->
      msg.send url

  robot.respond /(IF .*), ((ARE|CAN|DO|DOES|HOW|IS|MAY|MIGHT|SHOULD|THEN|WHAT|WHEN|WHERE|WHICH|WHO|WHY|WILL|WON\'T|WOULD)[ \'N].*)/i, (msg) ->
    memeGenerator msg, 17, 984, msg.match[1], msg.match[2] + (if msg.match[2].search(/\?$/)==(-1) then '?' else ''), (url) ->
      msg.send url

  robot.respond /((Oh|You) .*) ((Please|Tell) .*)/i, (msg) ->
    memeGenerator msg, 542616, 2729805, msg.match[1], msg.match[3], (url) ->
      msg.send url

memeResponder = (robot, meme) ->
  robot.respond meme.regex, (msg) ->
    memeGenerator msg, meme.generatorID, meme.imageID, msg.match[1], msg.match[2], (url) ->
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
