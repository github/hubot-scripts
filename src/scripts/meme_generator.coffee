# Generates images with memegenerator.net
#
# meme [me] <meme> [<top>|]<bottom> - Generates an image for <meme> with top text <top> and bottom text <bottom>
# 
# Y U NO <text>              - Generates the Y U NO GUY with the bottom caption
#                              of <text>
#
# I don't always <something> but when i do, <text> - Generates The Most Interesting man in the World
#
# <text> ALL the <things>    - Generates ALL THE THINGS
#
# <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#
# Good news everyone! <news> - Generates Professor Farnsworth

module.exports = (robot) ->
  memes =
    yuno:
      generator: 2
      image: 166088
    philosoraptor:
      generator: 17
      image: 984
    bachelorfrog:
      generator: 3
      image: 203
    insanitywolf:
      generator: 45
      image: 20
    sap:
      generator: 29
      image: 983
    decreux:
      generator: 54
      image: 42
    couragewolf:
      generator: 303
      image: 24
    foreveralone:
      generator: 116
      image: 142442
    fry:
      generator: 305
      image: 84688
    successkid:
      generator: 121
      image: 1031
    trollface:
      generator: 68
      image: 269
    interestingman:
      generator: 74
      image: 2485
    goodguygreg:
      generator: 534
      image: 699717
    yodawg:
      generator: 79
      image: 108785
    orly:
      generator: 920
      image: 117049
    all:
      generator: 6013
      image: 1121885
    toodamn:
      generator: 998
      image: 203665
    farnsworth:
      generator: 1591
      image: 112464
      
  robot.respond /meme(?:\s+me)?\s+(\S+)(\s+[^|]+)?(?:\s*\|\s*(.*))?/i, (msg) ->
    memeName = msg.match[1].toLowerCase()
    topText = if msg.match[2]? then msg.match[2].trim() else ''
    bottomText = if msg.match[3]? then msg.match[3].trim() else ''
    meme = memes[memeName]
    if meme?
      memeGenerator msg, meme.generator, meme.image, topText, bottomText, (url) ->
        msg.send url
    else
      msg.reply "I don't know that meme."

  robot.respond /Y U NO (.+)/i, (msg) ->
    caption = msg.match[1] || ""
    memeGenerator msg, 2, 166088, "Y U NO", caption, (url) ->
      msg.send url

  robot.respond /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, (msg) ->
    memeGenerator msg, 74, 2485, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (ALL the .*)/, (msg) ->
    memeGenerator msg, 6013, 1121885, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (\w+\sTOO DAMN .*)/i, (msg) ->
    memeGenerator msg, 998, 203665, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(GOOD NEWS EVERYONE[,.!]?) (.*)/i, (msg) ->
    memeGenerator msg, 1591, 112464, msg.match[1], msg.match[2], (url) ->
      msg.send url

memeGenerator = (msg, generatorID, imageID, text0, text1, callback) ->
  username = process.env.HUBOT_MEMEGEN_USERNAME
  password = process.env.HUBOT_MEMEGEN_PASSWORD

  unless username
    msg.send "MemeGenerator username isn't set. Sign up at http://memegenerator.net"
    msg.send "Then set the HUBOT_MEMEGEN_USERNAME environment variable"
    return

  unless password
    msg.send "MemeGenerator password isn't set. Sign up at http://memegenerator.net"
    msg.send "Then set the HUBOT_MEMEGEN_PASSWORD environment variable"
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
      if result['instanceUrl']? and result['instanceImageUrl']?
        instanceURL = result['instanceUrl']
        img = "http://memegenerator.net" + result['instanceImageUrl']
        msg.http(instanceURL).get() (err, res, body) ->
          # Need to hit instanceURL so that image gets generated
          callback img
      else
        msg.reply "Sorry, I couldn't generate that image."
