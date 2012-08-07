# Description:
#   Return Hubot's external IP address (via jsonip.com)
#
# Dependencies:
#   None
#
# Configuration:
#  None
# 
# Commands:
#   hubot ip - Returns Hubot server's external IP address 
#
# Author:
#   ndrake
     
module.exports = (robot) ->
  robot.respond /ip/i, (msg) ->
    msg.http("http://jsonip.com")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode                                
          when 200
            msg.send "External IP address: #{json.ip}"
          else
            msg.send "There was an error getting external IP (status: #{res.statusCode})."
                

