# Integrates with memegenerator.net
#
# Y U NO <text>              - Generates the Y U NO GUY with the bottom caption
#                              of <text>
#
# I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#
# <text> ORLY?               - Generates the ORLY? owl with the top caption of <text>
#
# <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#
# <text> ALL the <things>    - Generates ALL THE THINGS

module.exports = (robot) ->
  robot.respond /Y U NO (.+)/i, (msg) ->
    caption = msg.match[1] || ""

    memeGenerator msg, 2, 166088, "Y U NO", caption, (url) ->
      msg.send url

  robot.respond /(I DON'?T ALWAYS .*) (BUT WHEN I DO .*)/i, (msg) ->
    memeGenerator msg, 74, 2485, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(O\s?RLY\??.*)/i, (msg) ->
    memeGenerator msg, 920, 117049, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(SUCCESS|NAILED IT.*)/i, (msg) ->
    memeGenerator msg, 121, 1031, msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (ALL the .*)/, (msg) ->
    memeGenerator msg, 6013, 1121885, msg.match[1], msg.match[2], (url) ->
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
      instanceURL = result['instanceUrl']
      img = "http://memegenerator.net" + result['instanceImageUrl']

      msg.http(instanceURL).get() (err, res, body) ->
        # Need to hit instanceURL so that image gets generated
        callback img
