# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot achievement get <achievement> [achiever's gravatar email] - life goals are in reach
#
# Author:
#   Chris

module.exports = (robot) ->
  robot.hear /achievement (get|unlock(ed)?) (.+?)(\s*[^@\s]+@[^@\s]+)?\s*$/i, (msg) ->
    caption = msg.match[3]
    email = msg.match[4] || msg.message.user.email_address
    url = "http://achievement-unlocked.heroku.com/xbox/#{escape(caption)}.png"
    if email
      url += "?email=#{escape(email.trim())}.png"
    msg.send(url)
