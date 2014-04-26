# Description:
#   A sourcing.io Hubot client
#
# Dependencies:
#   None
#
# Configuration:
#   SOURCING_IO_API_KEY
#
# Commands:
#   hubot sourcing --email <email address>
#   hubot sourcing --twitter <twitter handle>
#   hubot sourcing --github <github username>
#
# Notes:
#   I'm lazy and won't implement a command for https://sourcing.io/api#people-search
#   Someone with a good idea of what the command would look like is welcome to take a pass.
#
# Author:
#   alec666

constructMessage = (body) ->
  try
    json = JSON.parse(body)
    return "   #{json.name}\n
      #{json.headline}\n
      located: #{json.location}\n
      languages: #{json.languages}\n
      email: #{json.email}\n
      score: #{json.score}"
  catch error
    return "There was a problem generating the response."

module.exports = (robot) ->
  
  # Check SourcingIO config. Log and bail if unset. 
  if process.env.SOURCING_IO_API_KEY?
    sourcing_io_api_key = process.env.SOURCING_IO_API_KEY
  else
    console.log "Missing SOURCING_IO_API_KEY"
    return false

  # Authorization header
  auth = 'Bearer ' + process.env.SOURCING_IO_API_KEY

  # Find by email
  robot.respond /sourcing --email (.*)/i, (msg) ->

    email = escape(msg.match[1])

    msg.http("https://api.sourcing.io/v1/people/email/" + email)
      .headers(Authorization: auth)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send constructMessage body
          when 404
            msg.send "Sourcing.io doesn't have a record for that email address."

  # Find by twitter 
  robot.respond /sourcing --twitter @(.+)/, (msg) ->
  
    handle = escape(msg.match[1])

    msg.http("https://api.sourcing.io/v1/people/twitter/" + handle)
      .headers(Authorization: auth)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send constructMessage body
          when 404
            msg.send "Sourcing.io doesn't have a record for that handle."

  # Find by Github 
  robot.respond /sourcing --github (.+)/, (msg) ->
  
    username = escape(msg.match[1])

    msg.http("https://api.sourcing.io/v1/people/github/" + username)
      .headers(Authorization: auth)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send constructMessage body
          when 404
            msg.send "Sourcing.io doesn't have a record for that Github username."
        