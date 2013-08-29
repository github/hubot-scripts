#
# Description:
#   Hubble Movie information is displayed.
#
# Dependencies:
#   None
#
# Commands:
#   hubble me <query>  - Movie information is displayed 
#   hub me <query>
#
# Author:
#   cobaimelan

getMovie = (msg) ->
  query = msg.match[3]
  msg.http('http://hububble.herokuapp.com/movie/?')
    .query(q: query)
    .get() (err, res, body) ->
      results = JSON.parse(body)
      if results.eror
        msg.send "eror"
        return
      msg.send "Movie title : #{results.title}"
      msg.send "Movie year : #{results.year}"
      msg.send "Movie artist : #{results.artist}"
      msg.send "Movie description  : #{results.desc}"

module.exports = (robot) ->
  robot.respond /(hubble|hub)( me)? (.*)/i, (msg) ->
    getMovie(msg)