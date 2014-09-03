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
#   hubot joke me <list> - Pull a random joke from /r/<list>
#
# Examples:
#   hubot joke me dad - pulls a random dad joke
#   hubot joke me mom - pulls a random momma joke
#   hubot joke me clean - pulls a random clean joke
#   hubot joke me classy - pulls a random classic joke
#
# Author:
#   tombell, ericjsilva

module.exports = (robot) ->

  robot.respond /joke me(.*)$/i, (msg) ->
    name = msg.match[1].trim()

    if name is "dad"
      url = "dadjokes"
    else if name is "clean"
      url = "cleanjokes"
    else if name is "mom"
      url = "mommajokes"
    else if name is "classy"
      url = "classyjokes"
    else
      url = "jokes"

    msg.http("http://www.reddit.com/r/#{url}.json")
    .get() (err, res, body) ->
      try
        data = JSON.parse body
        children = data.data.children
        joke = msg.random(children).data

        joketext = joke.title.replace(/\*\.\.\.$/,'') + ' ' + joke.selftext.replace(/^\.\.\.\s*/, '')

        msg.send joketext.trim()

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"