# Description:
#   Rage face script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rage <tag> - Send a rageface for a given tag, if no tag is given, one will be chosen at random
#
# Author:
#   brianmichel

Array::shuffle = -> @sort -> 0.5 - Math.random()
String::strip = -> if String::trim? then @trim() else @replace /^\s+|\s+$/g, ""

emotions = [
	"happy",
	"rage",
	"AW YEAH",
	"money",
	"cereal",
	"guy",
	"accepted",
	"derp",
	"fuck"
	]

module.exports = (robot) ->
	robot.respond /(rage)( .*)?/i, (msg) ->
		tag = if msg.match[2] then msg.match[2] else msg.random emotions
		rageFacesCall msg, tag, (image_url) ->
			msg.send image_url

rageFacesCall = (msg, tag, cb) ->
	encoded_tag = encodeURI tag.strip()
	rage_faces_url = "http://ragefac.es/api/tag/" + encoded_tag
	msg.http(rage_faces_url)
		.get() (err, res, body) ->
			json_body = JSON.parse(body)
			items = json_body.items.shuffle()
			cb if items.length > 1 then items[0].face_url else "Unable to rage"
