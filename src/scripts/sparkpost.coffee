# Description:
#   interacts with the Sparkpost reporting API.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SPARKPOST_API_TOKEN your API token with reporting privileges
#   HUBOT_SPARKPOST_TIMEZONE the timezone (default America/New_York)
#
# Commands:
#   !sparkpost <email>
#
# Notes:
#
# Author:
#   postwait

env = process.env

tz = if env.HUBOT_SPARKPOST_TIMEZONE then env.HUBOT_SPARKPOST_TIMEZONE else "America/New_York"
api_url = "https://api.sparkpost.com/api/v1/message-events?timezone=#{tz}&recipients="
api_reporting_token = env.HUBOT_SPARKPOST_API_TOKEN

tssimple = (a) ->
  a.replace("T", " ").replace(".000", " (") + ")"

module.exports = (robot) ->
  robot.hear /!sparkpost\s+(.*)$/i, (res) ->
    if res.match[1] == 'help'
      res.send "!sparkpost <email> -> show event logs involving the specified email address\n"
      return
    robot.http(api_url + res.match[1].toLowerCase())
        .header('Authorization', api_reporting_token)
        .header('Accept', 'application/json')
        .get() (err, httpres, body) ->
          if err
            res.send "Encountered an error :( #{err}"
            return

          data = JSON.parse(body)
          out = (i) ->
            type = i.type
            tsstr = tssimple(i.timestamp)
            if i.reason
              type = "#{type} '#{i.reason}'"
            return "[#{tsstr}] (#{type} of #{i.template_id}) to #{i.raw_rcpt_to} \"#{i.subject}\""
          if (! data.results?)
            res.send "No results returned: #{body}"
            return
          if data.results.length == 0
            res.send "No logs for #{ res.match[1] }"
            return
          payload = (out(d) for d in data.results.reverse()).join("\n")
          res.send "Logs for #{ res.match[1] }\n#{payload}"
