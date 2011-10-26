# Returns the URL of the first google hit for a query
#
# google me <query>   - Googles <query> & returns 1st result's URL

module.exports = (robot) ->
  robot.respond /(google)( me)? (.*)/i, (msg) ->
    googleMe msg, msg.match[3], (url) ->
      msg.send url

googleMe = (msg, query, cb) ->
  msg.http('http://www.google.com/search')
    .query(q: query)
    .get() (err, res, body) ->
      cb body.match(/<a href="([^"]*)" class=l>/)?[1] || "Sorry, Google had zero results for '#{query}'"

