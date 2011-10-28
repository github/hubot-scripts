#
# achievement get <achievement> [achiever's email] - life goals are in reach.
#
module.exports = (robot) ->
  robot.hear /achievement get (.+?)((?:\s*)[^@\s]+@[^@\s]+)?$/i, (msg) ->
    caption = msg.match[1]
    email = msg.match[2]
    url = "http://achievement-unlocked.heroku.com/xbox/#{escape(caption)}.png"
    if email
      url += "?email=#{escape(email.trim())}.png"
    msg.send(url)