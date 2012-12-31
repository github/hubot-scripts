# Description:
#   Messing around with the Coderwall API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot coderwall <coderwall username> - Returns coder achievements from coderwall.com
#
# Author:
#   mexitek

module.exports = (robot) ->
  robot.respond /(coderwall)( me)? (.*)/i, (msg) ->
    user = msg.match[3]
    msg.http("https://coderwall.com/"+user+".json")
      .get() (err, res, body) ->
        # If not response bad username
        if res.headers['content-length'] <= 1
          letter_s = if user.substr(-1)=='s' then '' else 's'
          msg.send "Sorry I cannot find "+user+"'"+letter_s+" coderwall"
        # Else return the coder badges
        else
          profile = JSON.parse(body)
          # Give an intro to the coderwall profile
          resp_str = profile.name + " from " + profile.location + " \n"
          resp_str += "coderwall -> http://coderwall.com/"+user + "\n"
          resp_str += "github -> https://github.com/" + profile.accounts.github + "\n"
          resp_str += profile.username + " has " + profile.endorsements + " endorsements and " + profile.badges.length + " badges\n"
          # Iterate all badges and continue building string
          profile.badges.forEach (badge) ->
            resp_str += "[" + badge.name + "] - " + badge.description + "\n"
          # Return response
          msg.send resp_str
