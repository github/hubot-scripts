# Talklikewarrenellis.com random quote builder
# Receive a random quote from the warren ellis generator (sometimes NSFW, but that's warren ellis for you.)
# 
# @hu talk like warren ellis - "Good afternoon, deathwatch orgasm lesions. hahaha suffer"
# @hu good morning - "Good evening, squid of death."
# @hu ellis - "ATTENTION MEATBAGS: Everyone take their clothes off now."
module.exports = (robot) ->

  robot.respond /(talk like warren ellis|ellis)/i, (msg) ->
    msg.http("http://talklikewarrenellis.com/random.php")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).quote

  robot.respond /good (morning|afternoon|evening|day|night)/i, (msg) ->
    msg.http("http://talklikewarrenellis.com/random.php")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).quote

