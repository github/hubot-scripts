# Description:
#   Generates memes via the Imgflip Meme Generator API
#
# Dependencies:
#   None
#
# Configuration:
#   IMGFLIP_API_USERNAME [optional, overrides default imgflip_hubot account]
#   IMGFLIP_API_PASSWORD [optional, overrides default imgflip_hubot account]
#
# Commands:
#   hubot One does not simply <text> - Lord of the Rings Boromir
#   hubot I don't always <text> but when i do <text> - The Most Interesting man in the World
#   hubot aliens <text> - Ancient Aliens History Channel Guy
#   hubot grumpy cat <text> - Grumpy Cat with text on the bottom
#   hubot <text>, <text> everywhere - X, X Everywhere (Buzz and Woody from Toy Story)
#   hubot Not sure if <text> or <text> - Futurama Fry
#   hubot Y U NO <text> - Y U NO Guy
#   hubot Brace yourselves <text> - Brace Yourselves X is Coming (Imminent Ned, Game of Thrones)
#   hubot <text> all the <text> - X all the Y
#   hubot <text> that would be great - Bill Lumbergh from Office Space
#   hubot <text> too damn <text> - The rent is too damn high
#   hubot Yo dawg <text> so <text> - Yo Dawg Heard You (Xzibit)
#   hubot <text> you're gonna have a bad time - Super Cool Ski Instructor from South Park
#   hubot Am I the only one around here <text> - The Big Lebowski
#   hubot What if I told you <text> - Matrix Morpheus
#   hubot <text> ain't nobody got time for that
#   hubot <text> I guarantee it - George Zimmer
#   hubot <text> and it's gone - South Park Banker Guy
#   hubot <text> nobody bats an eye <text> everyone loses their minds - Heath Ledger Joker
#   hubot back in my day <text> - Grumpy old man
#
# Author:
#   dylanwenzlau


inspect = require('util').inspect

module.exports = (robot) ->
  unless robot.brain.data.imgflip_memes?
    robot.brain.data.imgflip_memes = [
      {
        regex: /(one does not simply) (.*)/i,
        template_id: 61579
      },
      {
        regex: /(i don'?t always .*) (but when i do,? .*)/i,
        template_id: 61532
      },
      {
        regex: /aliens ()(.*)/i,
        template_id: 101470
      },
      {
        regex: /grumpy cat ()(.*)/i,
        template_id: 405658
      },
      {
        regex: /(.*),? (\1 everywhere)/i,
        template_id: 347390
      },
      {
        regex: /(not sure if .*) (or .*)/i,
        template_id: 61520
      },
      {
        regex: /(y u no) (.+)/i,
        template_id: 61527
      },
      {
        regex: /(brace yoursel[^\s]+) (.*)/i,
        template_id: 61546
      },
      {
        regex: /(.*) (all the .*)/i,
        template_id: 61533
      },
      {
        regex: /(.*) (that would be great|that'?d be great)/i,
        template_id: 563423
      },
      {
        regex: /(.*) (\w+\stoo damn .*)/i,
        template_id: 61580
      },
      {
        regex: /(yo dawg .*) (so .*)/i,
        template_id: 101716
      },
      {
        regex: /(.*) (.* gonna have a bad time)/i,
        template_id: 100951
      },
      {
        regex: /(am i the only one around here) (.*)/i,
        template_id: 259680
      },
      {
        regex: /(what if i told you) (.*)/i,
        template_id: 100947
      },
      {
        regex: /(.*) (ain'?t nobody got time for? that)/i,
        template_id: 442575
      },
      {
        regex: /(.*) (i guarantee it)/i,
        template_id: 10672255
      },
      {
        regex: /(.*) (a+n+d+ it'?s gone)/i,
        template_id: 766986
      },
      {
        regex: /(.* bats an eye) (.* loses their minds?)/i,
        template_id: 1790995
      },
      {
        regex: /(back in my day) (.*)/i,
        template_id: 718432
      }
    ]

  for meme in robot.brain.data.imgflip_memes
    setupResponder robot, meme

setupResponder = (robot, meme) ->
  robot.respond meme.regex, (msg) ->
    generateMeme msg, meme.template_id, msg.match[1], msg.match[2]

generateMeme = (msg, template_id, text0, text1) ->
  username = process.env.IMGFLIP_API_USERNAME
  password = process.env.IMGFLIP_API_PASSWORD

  if (username or password) and not (username and password)
    msg.reply 'To use your own Imgflip account, you need to specify username and password!'
    return

  if not username
    username = 'imgflip_hubot'
    password = 'imgflip_hubot'

  msg.http('https://api.imgflip.com/caption_image')
  .query
      template_id: template_id,
      username: username,
      password: password,
      text0: text0,
      text1: text1
  .post() (error, res, body) ->
    if error
      msg.reply "I got an error when talking to imgflip:", inspect(error)
      return

    result = JSON.parse(body)
    success = result.success
    errorMessage = result.error_message

    if not success
      msg.reply "Imgflip API request failed: #{errorMessage}"
      return

    msg.send result.data.url
