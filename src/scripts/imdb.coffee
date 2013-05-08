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
    msg.http("http://imdbapi.org/?=hope+floats&type=json&plot=simple&episode=0&limit=1&yg=0&mt=none&lang=en-US&offset=&aka=simple&release=simple&business=0&tech=0")
      .query({
        limit: 1
        type: 'json'
        plot: 'simple'
        title: query
      })
      .get() (err, res, body) ->
        list = JSON.parse(body)
        if movie = list[0]
          msg.send "#{movie.poster}#.png" if movie.poster
          msg.send "#{movie.plot_simple}\n\n#{movie.imdb_url}"
        else
          msg.send "That's not a movie, yo."
