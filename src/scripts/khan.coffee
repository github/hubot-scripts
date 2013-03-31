# Description:
#   Displays and/or generates images for the popular Khan meme
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_MEMEGENERATOR_USER -- Username on MemeGenerator.net
#   HUBOT_MEMEGENERATOR_PASS -- Password for account on MemeGenerator.net
#
# Commands:
#   khan <name>
#
# Notes:
#   None
#
# Author:
#   jonursenbach

module.exports = (robot) ->
  robot.hear /khan (.*)/i, (msg) ->
    name = msg.match[1]
    name += Array(5).join name.slice(-1)

    generateMeme msg, 6443, 1123022, name

generateMeme = (msg, generatorID, imageID, msg1) ->
  if not process.env.HUBOT_MEMEGENERATOR_USER
    msg.send "Error: You must specify your MemeGenerator.net username"
  if not process.env.HUBOT_MEMEGENERATOR_PASS
    msg.send "Error: You must specify your MemeGenerator.net pasword"
  if not (process.env.HUBOT_MEMEGENERATOR_USER and process.env.HUBOT_MEMEGENERATOR_PASS)
    return

  url = 'http://version1.api.memegenerator.net/Instance_Create?'
  url += 'username=' + process.env.HUBOT_MEMEGENERATOR_USER + '&'
  url += 'password=' + process.env.HUBOT_MEMEGENERATOR_PASS + '&'
  url += 'languageCode=en&'
  url += 'generatorID=' + generatorID + '&'
  url += 'imageID=' + imageID + '&'
  url += 'text1=' + encodeURIComponent(msg1)

  msg.http(url).get() (err, res, body) ->
    resp = JSON.parse(body)
    msg.send resp.result.instanceImageUrl
