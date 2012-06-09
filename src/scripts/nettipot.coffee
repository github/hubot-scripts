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
#   hubot nettipot - Send scarring, horrifying image of a nettipot in use.
#
# Author
#   alexpgates

nettipot = "http://i.imgur.com/EIqdZ.gif"

module.exports = (robot) ->
  robot.respond /nettipot/i, (msg) ->
	    msg.send nettipot

  robot.respond /nettibomb/i, (msg) ->
	    msg.send nettipot
	    msg.send nettipot
	    msg.send nettipot
	    msg.send nettipot
	    msg.send nettipot
