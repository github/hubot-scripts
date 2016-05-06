# Description:
#   ASCII art
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ascii me <text> - Show text in ascii art
#
# Author:
#   atmos
Path        = require("path")
HubotScripts = require(Path.resolve(__dirname, "..", "hubot-scripts"))

module.exports = (robot) ->
  HubotScripts.deprecate(robot, __filename)
  robot.respond /ascii( me)? (.+)/i, (msg) ->
    msg
      .http("http://asciime.herokuapp.com/generate_ascii")
      .query(s: msg.match[2].split(' ').join('  '))
      .get() (err, res, body) ->
        msg.send body
