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
#   hubot memegen Y U NO <text>  - Generates the Y U NO GUY with the bottom caption of <text>
#   hubot memegen I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#   hubot memegen <text> ORLY? - Generates the ORLY? owl with the top caption of <text>
#   hubot memegen <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#   hubot memegen <text> ALL the <things> - Generates ALL THE THINGS
#   hubot memegen <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#   hubot memegen good news everyone! <news> - Generates Professor Farnsworth
#   hubot memegen khanify <text> - TEEEEEEEEEEEEEEEEEXT!
#   hubot memegen Not sure if <text> or <text> - Generates Futurama Fry
#   hubot memegen Yo dawg <text> so <text> - Generates Yo Dawg
#   hubot memegen ALL YOUR <text> ARE BELONG TO US - Generates Zero Wing with the caption of <text>
#   hubot memegen if <text>, <word that can start a question> <text>? - Generates Philosoraptor
#   hubot memegen <text> FUCK YOU - Angry Linus
#   hubot memegen (Oh|You) <text> (Please|Tell) <text> - Willy Wonka
#   hubot memegen <text> you're gonna have a bad time - Bad Time Ski Instructor
#   hubot memegen one does not simply <text> - Lord of the Rings Boromir
#   hubot memegen it looks like (you|you're) <text> - Generates Clippy
#   hubot memegen AM I THE ONLY ONE AROUND HERE <text> - The Big Lebowski
#   hubot memegen <text> NOT IMPRESSED - Generates McKayla Maroney
#   hubot memegen PREPARE YOURSELF <text> - Generates GoT
#   hubot memegen WHAT IF I TOLD YOU <text> - Generates Morpheus
#   hubot memegen <text> BETTER DRINK MY OWN PISS - Generates Bear Grylls
#   hubot memegen INTERNET KID <text>, <text> - Generates First-day-on-the-Internet Kid
# Author:
#   skalnik


inspect = require('util').inspect

module.exports = (robot) ->
  unless robot.brain.data.memes?
    robot.brain.data.memes = [
      {
        regex: /(memegen )?(Y U NO) (.+)/i,
        generatorID: 2,
        imageID: 166088
      },
      {
        regex: /(memegen )?(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i,
        generatorID: 74,
        imageID: 2485
      },
      {
        regex: /(memegen )?(.*)(O\s?RLY\??.*)/i,
        generatorID: 920,
        imageID: 117049
      },
      {
        regex: /(memegen )?(.*)(SUCCESS|NAILED IT.*)/i,
        generatorID: 121,
        imageID: 1031
      },
      {
        regex: /(memegen )?(.*) (ALL the .*)/i,
        generatorID: 6013,
        imageID: 1121885
      },
      {
        regex: /(memegen )?(.*) (\w+\sTOO DAMN .*)/i,
        generatorID: 998,
        imageID: 203665
      },
      {
        regex: /(memegen )?(GOOD NEWS EVERYONE[,.!]?) (.*)/i,
        generatorID: 1591,
        imageID: 112464
      },
      {
        regex: /(memegen )?(NOT SURE IF .*) (OR .*)/i,
        generatorID: 305,
        imageID: 84688
      },
      {
        regex: /(memegen )?(YO DAWG .*) (SO .*)/i,
        generatorID: 79,
        imageID: 108785
      },
      {
        regex: /(memegen )?(ALL YOUR .*) (ARE BELONG TO US)/i,
        generatorID: 349058,
        imageID: 2079825
      },
      {
        regex: /(memegen )?(.*) (FUCK YOU)/i,
        generatorID: 1189472,
        imageID: 5044147
      },
      {
        regex: /(memegen )?(.*) (You'?re gonna have a bad time)/i,
        generatorID: 825296,
        imageID: 3786537
      },
      {
        regex: /(memegen )?(one does not simply) (.*)/i,
        generatorID: 274947,
        imageID: 1865027
      },
      {
        regex: /(memegen )?(grumpy cat) (.*),(.*)/i,
        generatorID: 1590955,
        imageID: 6541210
      },
      {
        regex: /(memegen )?(it looks like you're|it looks like you) (.*)/i,
        generatorID: 20469,
        imageID: 1159769
      },
      {
        regex: /(memegen )?(AM I THE ONLY ONE AROUND HERE) (.*)/i,
        generatorID: 953639,
        imageID: 4240352
      }
      {
        regex: /(memegen)?(.*)(NOT IMPRESSED*)/i,
        generatorID: 1420809,
        imageID: 5883168
      },
      {
        regex: /(memegen)?(PREPARE YOURSELF) (.*)/i,
        generatorID: 414926,
        imageID: 2295701
      },
      {
        regex: /(memegen)?(WHAT IF I TOLD YOU) (.*)/i,
        generatorID: 1118843,
        imageID: 4796874
      },
      {
        regex: /(memegen)?(.*) (BETTER DRINK MY OWN PISS)/i,
        generatorID: 92,
        imageID: 89714
      },
      {
        regex: /(memegen)? ?INTERNET KID ?([^,]*),?(.*)/i,
        generatorID: 1095654,
        imageID: 4714007
      }
    ]

  for meme in robot.brain.data.memes
    memeResponder robot, meme

  robot.respond /(memegen )?add meme \/(.+)\/i,(.+),(.+)/i, (msg) ->
    meme =
      regex: new RegExp(msg.match[2], "i")
      generatorID: parseInt(msg.match[3])
      imageID: parseInt(msg.match[4])

    robot.brain.data.memes.push meme
    memeResponder robot, meme

  robot.respond /(memegen )?k(?:ha|ah)nify (.*)/i, (msg) ->
    if Math.random() > 0.5
      # Kirk khan
      memeGenerator msg, 6443, 1123022, "", khanify(msg.match[2]), (url) ->
        msg.send url
    else
      # Spock khan
      memeGenerator msg, 2103732, 8814557, "", khanify(msg.match[2]), (url) ->
        msg.send url


  robot.respond /(memegen )?(IF .*), ((ARE|CAN|DO|DOES|HOW|IS|MAY|MIGHT|SHOULD|THEN|WHAT|WHEN|WHERE|WHICH|WHO|WHY|WILL|WON\'T|WOULD)[ \'N].*)/i, (msg) ->
    memeGenerator msg, 17, 984, msg.match[2], msg.match[3] + (if msg.match[3].search(/\?$/)==(-1) then '?' else ''), (url) ->
      msg.send url

  robot.respond /(memegen )?((Oh|You) .*) ((Please|Tell) .*)/i, (msg) ->
    memeGenerator msg, 542616, 2729805, msg.match[2], msg.match[4], (url) ->
      msg.send url

memeResponder = (robot, meme) ->
  robot.respond meme.regex, (msg) ->
    memeGenerator msg, meme.generatorID, meme.imageID, msg.match[2], msg.match[3], (url) ->
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
      if err
        msg.reply "Ugh, I got an exception trying to contact memegenerator.net:", inspect(err)
        return

      jsonBody = JSON.parse(body)
      success = jsonBody.success
      errorMessage = jsonBody.errorMessage
      result = jsonBody.result

      if not success
        msg.reply "Ugh, stupid request to memegenerator.net failed: \"#{errorMessage}.\" What does that even mean?"
        return

      instanceID = result?.instanceID
      instanceURL = result?.instanceUrl
      img = result?.instanceImageUrl

      unless instanceID and instanceURL and img
        msg.reply "Ugh, I got back weird results from memegenerator.net. Expected an image URL, but couldn't find it in the result. Here's what I got:", inspect(jsonBody)
        return

      msg.http(instanceURL).get() (err, res, body) ->
        # Need to hit instanceURL so that image gets generated
        if preferredDimensions?
          callback "http://images.memegenerator.net/instances/#{preferredDimensions}/#{instanceID}.jpg"
        else
          callback "http://images.memegenerator.net/instances/#{instanceID}.jpg"

khanify = (msg) ->
  msg = msg.toUpperCase()
  vowels = [ 'A', 'E', 'I', 'O', 'U' ]
  index = -1
  for v in vowels when msg.lastIndexOf(v) > index
    index = msg.lastIndexOf(v)
  "#{msg.slice 0, index}#{Array(10).join msg.charAt(index)}#{msg.slice index}!!!!!"
