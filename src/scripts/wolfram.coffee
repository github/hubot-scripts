# Allows hubot to answer almost any question by asking Wolfram Alpha
#
# Set the HUBOT_WOLFRAM_APPID environment var to your AppID
#
# question <question> - Searches Wolfram Alpha for the answer to the question.

Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

module.exports = (robot) ->
  robot.respond /(question|wfa) (.*)$/i, (msg) ->
    console.log msg.match
    Wolfram.query msg.match[2], (e, result) ->
      # console.log result
      if result and result.length > 0
        msg.send result[1]['subpods'][0]['value']
      else
        msg.send 'Hmm...not sure'
