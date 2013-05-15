# Description:
#   Displays and/or generates images for the popular Futurama memes
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_MEMEGENERATOR_USERNAME -- Username on MemeGenerator.net
#   HUBOT_MEMEGENERATOR_PASSWORD -- Password for account on MemeGenerator.net
#
# Commands:
#   not sure if <something> or <something else> - Generates a Futurama Fry meme
#   <something> is bad and you should feel bad - Generates a Zoidberg meme
#   <things> are bad and you should feel bad - Generates a Zoidberg meme
#	  futurama fry - Shows a random Futurama Fry meme
#   <question> why not zoidberg? - Generates a Why Not Zoidberg? meme
#   <something> does not work that way! - Generates a Morbo meme
#   <things> do not work that way! - Generates a Morbo meme
#   hypnotoad - ALL GLORY TO THE HYPNOTOAD
#   don't want to live - Shows the Professor's "don't want to live on this planet anymore" meme
#   shut up and take my money - Shows the Fry meme
#
# Notes:
#   None
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.hear /not sure if (.*) or (.*)/i, (msg) ->
    generateMeme msg, 305, 84688, "not sure if #{ msg.match[1] }", "or #{ msg.match[2] }"

  robot.hear /(.*) is bad and you should feel bad/i, (msg) ->
    generateMeme msg, 12270, 1136171, "#{ msg.match[1] } is bad", "and you should FEEL bad!"

  robot.hear /(.*) are bad and you should feel bad/i, (msg) ->
    generateMeme msg, 12270, 1136171, "#{ msg.match[1] } are bad", "and you should FEEL bad!"

  robot.hear /(.*) why not zoidberg?/i, (msg) ->
    generateMeme msg, 135099, 1643190, msg.match[1], "why not zoidberg?"

  robot.hear /(.*) does not work that way/i, (msg) ->
    generateMeme msg, 2784, 1113725, msg.match[1], "does not work that way"

  robot.hear /(.*) do not work that way/i, (msg) ->
    generateMeme msg, 2784, 1113725, msg.match[1], "do not work that way"

  robot.hear /.*(hypnotoad).*/i, (msg) ->
    msg.send "http://i0.kym-cdn.com/photos/images/newsfeed/000/008/746/hypnotoadfullsize.gif"

  robot.hear /.*(don'?t want to live).*/i, (msg) ->
    msg.send "http://i0.kym-cdn.com/photos/images/newsfeed/000/126/314/3cd8a33a.png"

  robot.hear /shut up and take my money/i, (msg) ->
    msg.send "http://i.imgur.com/QlmfC.jpg"

  robot.hear /futurama fry/i, (msg) ->
    url = "http://version1.api.memegenerator.net/Instances_Select_ByPopular?languageCode=en&pageSize=24&urlName=Futurama-Fry"
    msg.http(url).get() (err, res, body) ->
      resp = JSON.parse(body)
      rand = msg.random resp.result
      msg.send rand.instanceImageUrl

generateMeme = (msg, generatorID, imageID, msg1, msg2) ->
  if not process.env.HUBOT_MEMEGENERATOR_USERNAME
    msg.send "Error: You must specify your MemeGenerator.net username"
  if not process.env.HUBOT_MEMEGENERATOR_PASSWORD
    msg.send "Error: You must specify your MemeGenerator.net pasword"
  if not (process.env.HUBOT_MEMEGENERATOR_USERNAME and process.env.HUBOT_MEMEGENERATOR_PASSWORD)
    return
  url = "http://version1.api.memegenerator.net/Instance_Create?username=#{ process.env.HUBOT_MEMEGENERATOR_USERNAME }&password=#{ process.env.HUBOT_MEMEGENERATOR_PASSWORD }&languageCode=en&generatorID=#{ generatorID }&imageID=#{ imageID }&text0=#{ encodeURIComponent(msg1) }&text1=#{ encodeURIComponent(msg2) }"
  msg.http(url).get() (err, res, body) ->
    resp = JSON.parse(body)
    msg.send resp.result.instanceImageUrl
