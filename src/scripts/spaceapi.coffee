# Description:
#   Get the open/close status of the configured hackerspace.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SPACEAPI_URL
#
# Commands:
#   hubot status - Displays the hackerspace status
#
# Author:
#   apfohl

module.exports = (robot) ->
  robot.respond /status/i, (msg) ->
    msg.http(process.env.HUBOT_SPACEAPI_URL)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        data = JSON.parse(body)
        status = data.space
  
        if data.api == "0.13"
  
          if data.state && data.state.open
            status += ' is open'
          else
            status += ' is closed'
  
          if data.state && data.state.lastchange
            status += ' since ' + (new Date(data.state.lastchange * 1000))
  
        else
  
          if data.open
            status += ' is open'
          else
            status += ' is closed'
  
          if data.lastchange
            status += ' since ' + (new Date(data.lastchange * 1000))
  
        msg.send status
