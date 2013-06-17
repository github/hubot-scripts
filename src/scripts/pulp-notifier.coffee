# Description:
#   Post pulp (pulpproject.org) related events using pulp event listner
#
# Dependencies:
#   "url" : ""
#   "querystring" : ""
#
# Configuration:
#   PULP_CHANNEL
#   PULP_DEBUG
#
#   Put http://<HUBOT_URL>:<PORT>/pulp/report as your event listner
#   You can also append "?target=#room1,#room2" to the URL to control the
#   message destination.
#
# Commands:
#   None
#
# URL:
#   /pulp/report
#
# Author:
#   lsjostro

url = require 'url'
querystring = require 'querystring'

module.exports = (robot) ->
  channel = process.env.PULP_CHANNEL or "#announce"
  debug = process.env.PULP_DEBUG?

  if robot.adapter.constructor.name is 'IrcBot'
    bold = (text) ->
      "\x02" + text + "\x02"
    underline = (text) ->
      "\x1f" + text + "\x1f"
  else
    bold = (text) ->
      text
    underline = (text) ->
      text

  handler = (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    data = req.body

    if debug
      console.log('query', query)
      console.log('data', data)

    user = {}
    user.room = if query.targets then channel + ',' + query.targets else channel
    user.type = query.type if query.type

    switch data.event_type
      when "repo.sync.start"
        robot.send user, "Pulp started repo sync for #{bold(data.payload.repo_id)}"
      when "repo.sync.finish"
        switch data.payload.result
          when "success"
            robot.send user, "Yay! #{bold(data.payload.repo_id)} successfully finished! (#{bold(data.payload.summary.packages.num_synced_new_rpms)} new packages)"
          when "failed"
            robot.send user, "Oh no! #{bold(data.payload.repo_id)} failed! (please check /var/log/pulp/pulp.log for details)"

  robot.router.post "/pulp/report", (req, res) ->
    handler req, res
    res.end ""
