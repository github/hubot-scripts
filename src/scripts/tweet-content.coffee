# detect tweet URL and send tweet content
module.exports = (robot) ->
	robot.hear /https?:\/\/(mobile\.)?twitter\.com\/.*?\/status\/([0-9]+)/i, (msg) ->
		msg.http("https://api.twitter.com/1/statuses/show/#{msg.match[2]}.json").get() (err, res, body) ->
			return if err or (res.statusCode != 200)

			tweet = JSON.parse(body)

			msg.send "@#{tweet.user.name}: #{tweet.text}"
