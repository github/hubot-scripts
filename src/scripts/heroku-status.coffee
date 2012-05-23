# Show current Heroku status
#
# heroku status - Returns the current Heroku status for app operations and tools
# heroku status issues <limit> - Returns a list of recent <limit> issues (default limit is 5)
# heroku status issue <id> - Returns a single issue by ID number

module.exports = (robot) ->
  robot.respond /heroku status$/i, (msg) ->
    msg.http("https://status.heroku.com/api/v3/current-status")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "Production:  #{json['status']['Production']}\n" +
                   "Development: #{json['status']['Development']}\n"
        catch error
          msg.send "Uh oh, I had trouble figuring out what the Heroku cloud is up to."
  robot.respond /heroku status issues\s?(\d*)/i, (msg) ->
    limit = msg.match[1] or 5
    msg.http("https://status.heroku.com/api/v3/issues?limit=#{limit}")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          body = ''
          for issue in json
            body += "[##{issue['id']}] #{issue['title']}"
            body += if issue['resolved'] then " (resolved)" else " (unresolved)"
            body += "\n"
          msg.send body
        catch error
          msg.send "Uh oh, I had trouble figuring out what the Heroku cloud is up to."
  robot.respond /heroku status issue (\d+)/i, (msg) ->
    msg.http("https://status.heroku.com/api/v3/issues/#{msg.match[1]}")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "Title:     #{json['title']}\n" +
                   "Resolved: #{json['resolved']}\n" +
                   "Created:  #{json['created_at']}\n" +
                   "Updated:  #{json['updated_at']}\n" +
                   "URL:      #{json['href']}\n"
        catch error
          msg.send "Uh oh, I had trouble figuring out what the Heroku cloud is up to."
