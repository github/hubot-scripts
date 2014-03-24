# Description:
#   Natural availability tracking.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   brb (or afk, or bbl)
#
# Author:
#   jmhobbs

module.exports = (robot) ->

	users_away = {}

	robot.hear( /./i, (msg) ->
		if users_away[msg.message.user.name] and msg.message.text != 'brb'
			msg.send "Welcome back " + msg.message.user.name + "!"
			delete users_away[msg.message.user.name]
		else
			for user, state of users_away
				substr = msg.message.text.substring(0, user.length+1)
				if substr.toLowerCase() == user.toLowerCase() + ':'
					msg.send user + " is currently away."
					break
		)

	robot.hear /\b(brb|afk|bbl|bbiab|bbiaf)\b/i, (msg) ->
		users_away[msg.message.user.name] = true
