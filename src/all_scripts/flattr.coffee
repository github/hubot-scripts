# Description:
#   Interact with the Flattr API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   thing me <id> - Returns information about a flattr thing
#   hubot user me <username> - Returns information about a flattr user
#   hubot search things <query> - Search flattrs things
#
# Author:
#   simon

module.exports = (robot) ->

  robot.respond /search things (.*)/i, (msg) ->
    query = msg.match[1]
    msg.http("https://api.flattr.com/rest/v2/things/search")
      .query(query: query)
      .headers(Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Flattr says: #{err}"
          return
        search = JSON.parse(body)
        msg.send "I found #{search.total_items} things when looking for \"#{query}\". The top 3 are:"
        things = search.things.slice(0,3)
        for thing in things
          msg.send "[#{thing.flattrs}] #{thing.title} (#{thing.url}) owned by #{thing.owner.username} -> #{thing.link}"


  robot.respond /user (?:me )?(?:http(?:s)?:\/\/flattr.com\/profile\/)?(.*)$/i, (msg) ->
    user = msg.match[1].trim()
    msg.http("https://api.flattr.com/rest/v2/users/#{user}")
      .headers(Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Flattr says: #{err}"
          return
        user = JSON.parse(body)
        if user.error == "not_found"
          msg.send "There is no user with that username..."
          return
        response = "Flattr user: #{user.username}"
        if user.firstname && user.lastname
          response = response + " (#{user.firstname} #{user.lastname})"
        else if user.firstname
          response = response + " (#{user.firstname})"
        else if user.lastname
          response = response + " (#{user.lastname})"
        if user.city || user.country
          response = response + " from "
          if user.city
            response = response + "#{user.city}, "
          if user.country
            response = response + "#{user.country}"
        if user.url
          response = response + " [#{user.url}]"

        msg.send response

        # Profile
        msg.send "More: #{user.link}"

  robot.hear /(?:http(?:s)?:\/\/flattr.com\/(?:t|thing)\/|thing me )(\d+)/i, (msg) ->
    id = msg.match[1]
    msg.http("https://api.flattr.com/rest/v2/things/#{id}")
      .headers(Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Flattr says: #{err}"
          return
        thing = JSON.parse(body)
        msg.send "Thing: [#{thing.flattrs}] #{thing.title} - #{thing.link}"

  robot.hear /(https?:\/\/[-a-zA-Z0-9+&@#/%?=~_|$!:,.;]*)/, (msg) ->
    url = msg.match[1]
    msg.http("https://api.flattr.com/rest/v2/things/lookup")
      .query('url': url)
      .headers(Accept: "application/json")
      .get() (err, res, body) ->
        if err
          return
        location = JSON.parse(body)
        if location.message == 'found'
          msg.http(location.location)
            .headers(Accept: "application/json")
            .get() (err, res, body) ->
              thing = JSON.parse(body)
              msg.send "Thing: [#{thing.flattrs}] #{thing.title} - #{thing.link}"
