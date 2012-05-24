# This is script is a copy of the Scout WebHook hubot script Tweaked
# for My App Status (http://myappstat.us)
#
# Announce My App Status notifications to a room sepecified by the URL.
#
# To use:
#   setup http://hostname/hubot/myappstatus/ROOMNUMBER as
#   your notification webook. If on Heroku lookup the hostname where
#   the hubot server is running. (e.g. my-hubot.herokuapp.com)
#
#   Check you are using a recent version of hubot in packages.json
#   to ensure the robot.router is available

module.exports = (robot) ->
  robot.router.post '/hubot/myappstatus/:room', (req, res) ->
    room = req.params.room

    # Parameters from the post are:
    # name=MyGreatApp
    # version=1.0
    # state=waiting for review
    # link=https://myappstat.us/team/blah/app/1
    #
    robot.messageRoom room, "#{req.body.name} #{req.body.version} is now #{req.body.state}: #{req.body.link}"

    # Send back an empty response
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()
