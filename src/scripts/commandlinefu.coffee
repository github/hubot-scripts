# Description:
#   Returns a command from commandlinefu.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot commandlinefu me - returns random command
#   hubot commandlinefu me <command> - random entry for the comand passed
#
# Author:
#   aaronott

module.exports = (robot) ->
  robot.respond /commandlinefu(?: me)? *(.*)?/i, (msg) ->
    query = if msg.match[1]
          "matching/#{msg.match[1]}/#{new Buffer(msg.match[1]).toString('base64')}/json"
        else 
          "random/json"
    command msg, "http://www.commandlinefu.com/commands/#{query}", (cmd) ->
      msg.send cmd

command = (msg, uri, cb) ->
  msg.http(uri)
    .get() (err, res, body) ->
      # The random call passes back a 302 to redirect to a new page, if this
      # happens we redirect through a recursive function call passing the new
      # location to retrieve
      if res.statusCode == 302
        command msg, res.headers.location, cb
      else
        # choose a random command from the returned list
        cc = msg.random JSON.parse(body)
        cb("-- #{cc.summary}\n#{cc.command}")
