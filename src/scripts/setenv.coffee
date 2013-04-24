# Description:
#   Set Hubot environent varibales.
#   Limited to HUBOT_* for security.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot setenv HUBOT_AWESOME true - set the environment variable HUBOT_AWESOME to true
#   hubot getenv HUBOT_AWESOME      - return the value of the environment variable HUBOT_AWESOME
#
# Author:
#   pepijndevos

module.exports = (robot) ->
  robot.respond /setenv (HUBOT_[A-Z_]+) (.*)/, (msg) ->
    env = msg.match[1]
    val = msg.match[2]
    process.env[env] = val;
    msg.reply "Setting " + env + " to " + val + "."

  robot.respond /getenv (HUBOT_[A-Z_]+)/, (msg) ->
    msg.reply(process.env[msg.match[1]])
