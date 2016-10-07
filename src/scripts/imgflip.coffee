# Description:
#   Integrates with imgflip.com, based on the original meme_generator script by shalnik
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_IMGFLIP_USERNAME
#   HUBOT_IMGFLIP_PASSWORD
#
# Commands:
#   Y U NO <text>  - Generates the Y U NO GUY with the bottom caption of <text>
#   I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#   <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#   <text> ALL the <things> - Generates ALL THE THINGS
#   <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#   khanify <text> - TEEEEEEEEEEEEEEEEEXT!
#   Yo dawg <text> so <text> - Generates Yo Dawg
#   ALL YOUR <text> ARE BELONG TO US - Generates Zero Wing with the caption of <text>
#   if <text>, <word that can start a question> <text>? - Generates Philosoraptor
#   (Oh|You) <text> (Please|Tell) <text> - Willy Wonka
#   <text> you're gonna have a bad time - Bad Time Ski Instructor
#   one does not simply <text> - Lord of the Rings Boromir
#   it looks like (you|you're) <text> - Generates Clippy
#   AM I THE ONLY ONE AROUND HERE <text> - The Big Lebowski
#   (PREPARE|BRACE) YOURSELF <text> - Generates GoT
#   WHAT IF I TOLD YOU <text> - Generates Morpheus
#   <text> BETTER DRINK MY OWN PISS - Generates Bear Grylls
# Author:
#   woogienoogie, TheGravee


inspect = require('util').inspect

module.exports = (robot) ->
  unless robot.brain.data.memes?
    robot.brain.data.memes = [
      {
        regex: /(Y U NO) (.+)/i,
        templateID: 61527
      },
      {
        regex: /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i,
        templateID: 61532
      },
      {
        regex: /(.*) (SUCCESS|NAILED IT.*)/i,
        templateID: 61544
      },
      {
        regex: /(.*) (ALL the .*)/i,
        templateID: 61533
      },
      {
        regex: /(.*) (\w+\sTOO DAMN .*)/i,
        templateID: 61580
      },
      {
        regex: /(YO DAWG .*) (SO .*)/i,
        templateID: 9660202
      },
      {
        regex: /(ALL YOUR .*) (ARE BELONG TO US)/i,
        templateID: 4503404
      },
      {
        regex: /(.*) (You'?re gonna have a bad time)/i,
        templateID: 4091197
      },
      {
        regex: /(one does not simply) (.*)/i,
        templateID: 61579
      },
      {
        regex: /(it looks like you're|it looks like you) (.*)/i,
        templateID: 11773497
      },
      {
        regex: /(AM I THE ONLY ONE AROUND HERE) (.*)/i,
        templateID: 225516
      },
      {
        regex: /(WHAT IF I TOLD YOU) (.*)/i,
        templateID: 11673689
      },
      {
        regex: /(.*) (BETTER DRINK MY OWN PISS)/i,
        templateID: 8347605
      }
    ]

  for meme in robot.brain.data.memes
    memeResponder robot, meme

  robot.respond /add meme \/(.+)\/i,(.+)/i, (msg) ->
    meme =
      regex: new RegExp(msg.match[2], "i")
      templateID: parseInt(msg.match[3])

    robot.brain.data.memes.push meme
    memeResponder robot, meme

  robot.respond /((BRACE|PREPARE) YOURSELF) (.*)/i, (msg) ->
    memeGenerator msg, 6774155, msg.match[1], msg.match[3], (url) ->
      msg.send url

  robot.respond /k(?:ha|ah)nify (.*)/i, (msg) ->
    memeGenerator msg, 2933690, "", khanify(msg.match[1]), (url) ->
      msg.send url

  robot.respond /(IF .*), ((ARE|CAN|DO|DOES|HOW|IS|MAY|MIGHT|SHOULD|THEN|WHAT|WHEN|WHERE|WHICH|WHO|WHY|WILL|WON\'T|WOULD)[ \'N].*)/i, (msg) ->
    memeGenerator msg, 11185927, msg.match[1], msg.match[2] + (if msg.match[2].search(/\?$/)==(-1) then '?' else ''), (url) ->
      msg.send url

  robot.respond /((Oh|You) .*) ((Please|Tell) .*)/i, (msg) ->
    memeGenerator msg, 7541968, msg.match[1], msg.match[3], (url) ->
      msg.send url

memeResponder = (robot, meme) ->
  robot.respond meme.regex, (msg) ->
    memeGenerator msg, meme.templateID, msg.match[1], msg.match[2], (url) ->
      msg.send url

memeGenerator = (msg, templateID, text0, text1, callback) ->
  username = process.env.HUBOT_IMGFLIP_USERNAME
  password = process.env.HUBOT_IMGFLIP_PASSWORD

  unless username? and password?
    msg.send "Imgflip account isn't setup. Sign up at http://imgflip.com"
    msg.send "Then ensure the HUBOT_IMGFLIP_USERNAME and HUBOT_IMGFLIP_PASSWORD environment variables are set"
    return

  text0fixed = encodeURI(text0)
  text1fixed = encodeURI(text1)

  urlgen = "http://api.imgflip.com/caption_image?username=#{username}&password=#{password}&template_id=#{templateID}&text0=#{text0fixed}&text1=#{text1fixed}"
  msg.http(urlgen)
    .get() (err, res, body) ->
      if err
        msg.reply "Ugh, I got an exception trying to contact imgflip.com:", inspect(err)
        return

      jsonBody = JSON.parse(body)
      success = jsonBody.success
      errorMessage = jsonBody.errorMessage
      result = jsonBody.data

      if not success
        msg.reply "Sorry, but imgflip is having issues. It's not my fault. Please don't hurt me."
        msg.reply urlgen
        return

      img = result?.url

      callback img

khanify = (msg) ->
  msg = msg.toUpperCase()
  vowels = [ 'A', 'E', 'I', 'O', 'U' ]
  index = -1
  for v in vowels when msg.lastIndexOf(v) > index
    index = msg.lastIndexOf(v)
  "#{msg.slice 0, index}#{Array(10).join msg.charAt(index)}#{msg.slice index}!!!!!"