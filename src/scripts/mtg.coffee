# Description:
#   Insert Pictures of Magic: The Gathering Cards
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cast <card name> - a picture of the named magic card
#
# Author:
#   djljr

querystring = require 'querystring';

module.exports = (robot) ->
  robot.respond /cast (.+)/i, (msg) ->
    url = "http://gatherer.wizards.com/Handlers/Image.ashx"
    card = msg.match[1] || "Dismal%20Failure"
    query = { type: "card", name: card }
    msg.send "#{url}?#{querystring.stringify(query)}#.jpg"
