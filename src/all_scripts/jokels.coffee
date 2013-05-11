# Description:
#   Returns a random joke from jokels.com
#
# Dependencies:
#   None
#
# Commands:
#   hubot joke/jokel/jokels - Returns a random joke from jokels.com
#
# Author:
#   sylturner

module.exports = (robot) ->
  robot.respond /(jokel|jokels|joke)/i, (msg) ->
    msg.http('http://jokels.com/random_joke').get() (err, res, body) ->
      joke = JSON.parse(body).joke
      vote = joke.up_votes - joke.down_votes
      msg.send "#{ joke.question }"
      setTimeout ->
        msg.send "#{ joke.answer }" 
        setTimeout ->
          msg.send "#{ vote } upvotes - #{ joke.bitly_url }"
        , 1000
       , 4000
