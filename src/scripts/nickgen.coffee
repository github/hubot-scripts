# Description:
#   Nickname generator
#
# Dependencies:
#   "cheerio": "0.10.5"
#
# Configuration:
#   None
#
# Commands:
#   hubot nick pirate <name> - Get your pirate name.
#   hubot nick wutang <name> - Get your Wutang Clan name.
#   hubot nick blues <name> - Get your Blues guitarist name.
#   hubot nick potter <name> - Get your Harry Potter universe name.
#   hubot nick hacker <name> - Get your l337 hacker name.
#
#   hubot nick help - explains usage
#
# Notes:
#   None
#
# Author:
#   @commadelimited

$ = require 'cheerio'

# what nickname do you want?
options =
	pirate:
		selector: ".normalText font b"
		uri: "http://mess.be/pirate-names-male.php"
		greeting: 'Arrr! Yer pirate name be: '
	wutang:
		selector: "center b font:not(.normalText)"
		uri: "http://mess.be/inickgenwuname.php"
		greeting: 'Your Wu-Tang Clan name is: '
	blues:
		selector: "center > .boldText"
		uri: "http://mess.be/inickgenbluesmalename.php"
		greeting: 'Welcome to the Crossroads: '
	potter:
		selector: "center .normalText font b"
		uri: "http://mess.be/harry-potter-names-male.php"
		greeting: 'Your Wizarding name is: '
	hacker:
		selector: "center > p.normalText > b"
		uri: "http://mess.be/inickgenhacker.php"
		greeting: 'Welcome to the Matrix: '

		# curl --data "species=human&number=1" http://swg.stratics.com/content/gameplay/characters/randomname.php

module.exports = (robot) ->
	robot.respond /nick ([^ ]+) (.+)/i, (msg) ->
		type = msg.match[1]

		if (!options[type])
			list = (" #{name}" for name of options)
			msg.send "Uh-oh, #{type} is not a legit option: choices are#{list}"
			return

		url = options[type]['uri']
		name = msg.match[2]
		selector = options[type]['selector']
		greeting = options[type]['greeting']
		data = "realname="+ name

		console.log(data)
		msg.http(url)
			.header("Content-Type", "application/x-www-form-urlencoded")
			.post(data) (err, res, body) ->
				response = greeting + $(body).find(selector).text().replace(/\n/g,'').replace(name,'')
				msg.send response

	robot.respond /nick help/i, (msg) ->
		count = Object.keys(options).length
		list = ("#{name}" for name of options)
		msg.send "Usage: nick <#{list}> <your name>"
