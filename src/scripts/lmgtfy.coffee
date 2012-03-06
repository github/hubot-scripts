# Tell Hubot to send a user a link to lmgtfy.com
#
# lmgtfy <optional @username> <some query>
#
# Examples
#
#   lmgtfy trollface zomg
#   lmgtf @Tyler font kerning
#
module.exports = (robot) ->
   robot.respond /lmgtfy?\s?(?:@(\w*))? (.*)/i, (msg) ->
     link = ""
     link += "#{msg.match[1]}: " if msg.match[1]
     link += "http://lmgtfy.com/?q=#{escape(msg.match[2])}"
     msg.send link