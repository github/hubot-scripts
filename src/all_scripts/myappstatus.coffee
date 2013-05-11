# Description:
#   This is script is a copy of the Scout WebHook hubot script Tweaked
#   for My App Status (http://myappstat.us)
# 
# Dependencies:
#   None
#
# Configuration:
#   setup http://hostname/hubot/myappstatus/ROOMNUMBER as
#   your notification webook. If on Heroku lookup the hostname where
#   the hubot server is running. (e.g. my-hubot.herokuapp.com)
#
# Commands:
#   None
#
# Author:
#   bricooke

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
