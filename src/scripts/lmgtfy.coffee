# Description:
#   Tell Hubot to send a user a link to lmgtfy.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot lmgtfy <optional @username> <some query>
#
# Author:
#   phlipper

module.exports = (robot) ->
   robot.respond /lmgtfy?\s?(?:@(\w*))? (.*)/i, (msg) ->
     link = ""
     link += "#{msg.match[1]}: " if msg.match[1]
     link += "http://lmgtfy.com/?q=#{escape(msg.match[2])}"
     msg.send link
