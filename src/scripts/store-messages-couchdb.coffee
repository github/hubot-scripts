# Description:
#   None
#
# Dependencies:
#   "cradle": "0.6.3"
#
# Configuration:
#   HUBOT_COUCHDB_URL
#
# Commands:
#   None
#
# Author:
#   Vrtak-CZ

Url    = require "url"
cradle = require "cradle"

# sets up hooks to persist all messages into couchdb.
module.exports = (robot) ->
	info   = Url.parse process.env.HUBOT_COUCHDB_URL || 'http://localhost:5984'
	if info.auth
		auth = info.auth.split(":")
		client = new(cradle.Connection) info.hostname, info.port, auth:
			username: auth[0]
			password: auth[1]
	else
		client = new(cradle.Connection)(info.hostname, info.port)

	db = client.database(if info.pathname != '/' then info.pathname.slice(1) else "hubot-storage")

	robot.hear /.*$/i, (msg) ->
		message = msg.message
		message.date = new Date

		# ignore topic and other messages
		return if typeof message.user.id == 'undefined'

		db.save message, (err, res) -> 
			if err then console.error(err)
