# Messing around with the Coderwall API.
#
# coderwall <coderwall username> - Returns coder achievements from coderwall.com
#                      
module.exports = (robot) ->
  robot.respond /(coderwall)( me)? (.*)/i, (msg) ->
    user = msg.match[3]
    msg.http("http://coderwall.com/"+user+".json")
      .get() (err, res, body) ->
        # If not response bad username
        if res.headers['content-length'] <= 1
          letter_s = if user.substr(-1)=='s' then '' else 's'
          msg.send "Sorry I cannot find "+user+"'"+letter_s+" coderwall" 
        # Else return the coder badges
        else 
          profile = JSON.parse(body)
          # Give an intro to the coderwall profile
          resp_str = "";
          resp_str += user + "'s coderwall -> http://coderwall.com/"+user + "\n"
          # Iterate all badges and continue building string
          profile.badges.forEach (badge) ->
            resp_str += badge.name + " - " + badge.description + "\n"
          # Return response
          msg.send resp_str