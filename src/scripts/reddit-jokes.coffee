# Description:
#   Random jokes from /r/jokes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot joke me - Pull a random joke from /r/jokes
#
# Author:
#   tombell

module.exports = (robot) ->

  robot.respond /joke me/i, (msg) ->
    msg.http('http://www.reddit.com/r/jokes.json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          children = data.data.children
          joke = msg.random(children).data

          if joke.selftext.match /^\.\.\./
            joketext = joke.title.replace(/\*\.\.\.$/,'') + ' ' + joke.selftext.replace(/^\.\.\.\s*/, '')
          else
            joketext = joke.selftext

          msg.send joketext.trim()

        catch ex
          msg.send "Erm, something went EXTREMELY wrong - #{ex}"
