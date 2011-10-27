# Show status of 3 most recent builds.
#
# You need to set the following variables:
# HUBOT_TEAMCITY_USERNAME = <user name>
# HUBOT_TEAMCITY_PASSWORD = <password>
# HUBOT_TEAMCITY_HOSTNAME = <host : port>
#
# show me builds -- Show status of currently running builds
module.exports = (robot) ->
  robot.respond /show (me )?builds/i, (msg) ->
    username = process.env.HUBOT_TEAMCITY_USERNAME
    password = process.env.HUBOT_TEAMCITY_PASSWORD
    hostname = process.env.HUBOT_TEAMCITY_HOSTNAME
    msg.http("http://#{hostname}/app/rest/builds")
      .query(locator: ["running:any", "count:3"].join(","))
      .headers(Authorization: "Basic #{new Buffer("#{username}:#{password}").toString("base64")}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Team city says: #{err}"
          return
        # Sort by build number.
        builds = JSON.parse(body).build.sort((a, b)-> parseInt(b.number) - parseInt(a.number))
        for build in builds
          if build.running
            started = Date.parse(build.startDate.replace(/(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})([+\-]\d{4})/, "$1-$2-$3T$4:$5:$6$7"))
            elapsed = (Date.now() - started) / 1000
            seconds = "" + Math.floor(elapsed % 60)
            seconds = "0#{seconds}" if seconds.length < 2
            msg.send "#{build.number}, #{build.percentageComplete}% complete, #{Math.floor(elapsed / 60)}:#{seconds} minutes"
          else if build.status is "SUCCESS"
            msg.send "#{build.number} is full of win"
          else if build.status is "FAILUED"
            msg.send "#{build.number} is #fail"
