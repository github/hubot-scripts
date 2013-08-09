#
# Description:
#   Get the movie poster and synposis for a given query
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot imdb the matrix
#
# Author:
#   orderedlist

module.exports = (robot) ->
  robot.respond /(imdb|movie)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    msg.http("http://mymovieapi.com/")
      .query({
        limit: 1
        type: 'json'
        plot: 'simple'
        q: query
      })
      .get() (err, res, body) ->
        list = JSON.parse(body)
        if movie = list[0]
          msg.send "#{movie.poster.cover}#.png" if movie.poster
          msg.send "#{movie.plot_simple}"
          msg.send "#{movie.imdb_url}"
        else
          msg.send "That's not a movie, yo."
