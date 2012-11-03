# Description:
# Returns a command from commandlinefu.com
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# show me some commandlinefu - returns random command
# show me some commandlinefu <command> - random entry for the comand passed
#
# Author:
#   aaronott
module.exports = (robot) ->
  robot.respond /(show me some )?(commandlinefu)\s*(.*)?/i, (msg) ->
    uri = "http://www.commandlinefu.com/commands/"
    c = msg.match[3]
    if c != undefined 
      query = "matching/" + c + "/" + new Buffer(c).toString('base64') + "/json"
    else 
      query = "random/json"
    uri = uri + query
    command msg, uri, (cmd) ->
      msg.send cmd

command = (msg, uri, cb) ->
  msg.http(uri)
    .header('User-Agent', 'Mozilla/5.0')
    .get() (err, res, body) ->
      # The random call passes back a 302 to redirect to a new page, if this
      # happens we redirect through a recursive function call passing the new
      # location to retrieve
      if res.statusCode == 302
        command msg, res.headers.location, cb
      else
        cl = JSON.parse(body)
        # choose a random command from the returned list
        cc = msg.random cl
        ret_str = "-- #{cc.summary}\n#{cc.command}"
        cb(ret_str)
