#
# nettipot - Send scarring, horrifying image of a nettipot in use.
# Written by @alexpgates
#

nettipot = "http://i.imgur.com/EIqdZ.gif"

module.exports = (robot) ->
  robot.respond /nettipot/i, (msg) ->
	    msg.send nettipot