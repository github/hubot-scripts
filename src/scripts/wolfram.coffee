# Allows hubot to answer almost any question by asking Wolfram Alpha
#
# Set the HUBOT_WOLFRAM_APPID environment var to your AppID
#
# question <question> - Searches Wolfram Alpha for the answer to the question.

Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

module.exports = (robot) ->
  robot.respond /question (.*)$/i, (msg) ->
    Wolfram.query msg.match[1], (e, result) ->
      # console.log result
      if result and result.length > 0
        msg.reply result[1]['subpods'][0]['value']
      else
        msg.reply 'Hmm...not sure.  Maybe I don\'t understand the question.'
