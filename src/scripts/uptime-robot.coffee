# Show uptime status of sites monitored by uptime robot.
#
# You need to set the following variables:
# HUBOT_UPTIMEROBOT_APIKEY = <apikey>
#
# what is the uptime of the monitored sites? -- Show the status of the monitored sites
# start monitoring the http uptime of <url> -- Instructs uptime robot to monitor the <url>

module.exports = (robot) ->
  apikey = process.env.HUBOT_UPTIMEROBOT_APIKEY

  robot.respond /what is the uptime of the monitored sites?/i, (msg) ->
    msg.http("http://api.uptimerobot.com/getMonitors")
      .query({ apiKey: apikey, logs: 0, format: "json", noJsonCallback: 1 })
      .get() (err, res, body) ->
        if err
          msg.send "Uptime robot says: #{err}"
          return

        response = JSON.parse(body)

        if response.stat is "ok"
          for monitor in response.monitors.monitor
            status = ""
            switch monitor.status
              when "1" then status = "paused"
              when "2" then status = "up"
              when "8" then status = "seems down"
              when "9" then status = "down"
              else status = "unknown"

            msg.send "#{monitor.friendlyname}: has an uptime of #{monitor.alltimeuptimeratio}% and current status of #{status}"
        else if response.stat is "fail"
          msg.send "Uhoh, #{response.message}";


  robot.respond /start monitoring the http uptime of (.*)$/i, (msg) ->
    monitorUrl = msg.match[1]
    monitorFriendlyName = msg.match[1]
    msg.http("http://api.uptimerobot.com/newMonitor")
      .query({ apiKey: apikey, monitorFriendlyName: monitorFriendlyName, monitorURL: monitorUrl, monitorType: 1, format: "json", noJsonCallback: 1 })
      .get() (err, res, body) ->
        response = JSON.parse(body)

        if response.stat is "ok"
          msg.send "done"

        if response.stat is "fail"
          msg.send "#{response.message}"