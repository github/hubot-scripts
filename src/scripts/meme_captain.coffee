# Description:
#   Get a meme from http://memecaptain.com/
#
# Dependencies:
#   None
#
# Commands:
#   hubot Y U NO <text> - Generates the Y U NO GUY with the bottom caption of <text>
#   hubot I don't always <something> but when i do <text> - Generates The Most Interesting man in the World
#   hubot <text> (SUCCESS|NAILED IT) - Generates success kid with the top caption of <text>
#   hubot <text> ALL the <things>    - Generates ALL THE THINGS
#   hubot <text> TOO DAMN <high> - Generates THE RENT IS TOO DAMN HIGH guy
#   hubot Not sure if <text> or <text> - Generates Futurama Fry
#   hubot Yo dawg <text> so <text> - Generates Yo Dawg
#   hubot ALL YOUR <text> ARE BELONG TO US - Generates Zero Wing with the caption of <text>
#   hubot If <text>, <word that can start a question> <text>? - Generates Philosoraptor
#   hubot <text>, BITCH PLEASE <text> - Generates Yao Ming
#   hubot <text>, COURAGE <text> - Generates Courage Wolf
#   hubot ONE DOES NOT SIMPLY <text> - Generates Boromir
#   hubot IF YOU <text> GONNA HAVE A BAD TIME - Ski Instructor
#   hubot IF YOU <text> TROLLFACE <text> - Troll Face
#
# Author:
#   bobanj

module.exports = (robot) ->
  robot.respond /Y U NO (.+)/i, (msg) ->
    memeGenerator msg, 'y_u_no.jpg', 'Y U NO', msg.match[1], (url) ->
      msg.send url

  robot.respond /(.*) (ALL the .*)/i, (msg) ->
    memeGenerator msg, 'all_the_things.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, (msg) ->
    memeGenerator msg, 'most_interesting.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)(SUCCESS|NAILED IT.*)/i, (msg) ->
    memeGenerator msg, 'success_kid.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*) (\w+\sTOO DAMN .*)/i, (msg) ->
    memeGenerator msg, 'too_damn_high.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(NOT SURE IF .*) (OR .*)/i, (msg) ->
    memeGenerator msg, 'fry.png', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(YO DAWG .*) (SO .*)/i, (msg) ->
    memeGenerator msg, 'xzibit.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)\s*BITCH PLEASE\s*(.*)/i, (msg) ->
    memeGenerator msg, 'yao_ming.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)\s*COURAGE\s*(.*)/i, (msg) ->
    memeGenerator msg, 'courage_wolf.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /ONE DOES NOT SIMPLY (.*)/i, (msg) ->
    memeGenerator msg, 'boromir.jpg', 'ONE DOES NOT SIMPLY', msg.match[1], (url) ->
      msg.send url

  robot.respond /(IF YOU .*\s)(.* GONNA HAVE A BAD TIME)/i, (msg) ->
    memeGenerator msg, 'bad_time.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)TROLLFACE(.*)/i, (msg) ->
    memeGenerator msg, 'troll_face.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(IF .*), ((ARE|CAN|DO|DOES|HOW|IS|MAY|MIGHT|SHOULD|THEN|WHAT|WHEN|WHERE|WHICH|WHO|WHY|WILL|WON\'T|WOULD)[ \'N].*)/i, (msg) ->
    memeGenerator msg, 'philosoraptor.jpg', msg.match[1], msg.match[2] + (if msg.match[2].search(/\?$/)==(-1) then '?' else ''), (url) ->
      msg.send url


memeGenerator = (msg, imageName, text1, text2, callback) ->
  imageUrl = "http://memecaptain.com/" + imageName

  processResult = (err, res, body) ->
    return msg.send err if err
    if res.statusCode == 301
      robot.http(res.headers.location).get() processResult
      return
    if res.statusCode > 300
      msg.reply "Sorry, I couldn't generate that meme. Unexpected status from memecaption.com: #{res.statusCode}"
      return
    try
      result = JSON.parse(body)
    catch error
      msg.reply "Sorry, I couldn't generate that meme. Unexpected response from memecaptain.com: #{body}"
    if result? and result['imageUrl']?
      callback result['imageUrl']
    else
      msg.reply "Sorry, I couldn't generate that meme."

  robot.http("http://memecaptain.com/g")
    .query(
      u: imageUrl,
      t1: text1,
      t2: text2
    ).get() processResult
