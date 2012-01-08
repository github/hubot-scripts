
twss = require 'twss'
module.exports = (robot) ->
  robot.hear /(.*)/i, (msg) ->
    msg.reply "That's what she said." if twss.is msg.message.text
