# joke me - Pull a random joke from /r/jokes

module.exports = (robot) ->

  robot.respond /joke me/i, (msg) ->
    msg.http('http://www.reddit.com/r/jokes.json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          children = data.data.children
          joke = msg.random(children).data.selftext
          msg.send joke

        catch ex
          msg.send "Erm, something went EXTREMELY wrong - #{ex}"
