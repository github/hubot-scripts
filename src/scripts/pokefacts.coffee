# Description:
#   Pokemon fun!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   pokefact - get a random pokefact!
#
# Author:
#   eliperkins

module.exports = (robot) ->

  robot.respond /pokefact/i, (msg) ->
    msg.http('https://api.twitter.com/1/statuses/user_timeline.json')
      .query(screen_name: 'pokefacts', count: 100)
      .get() (err, res, body) ->
        tweets = JSON.parse(body)
        msg.send tweets.length
        if tweets? and tweets.length > 0
          tweet = msg.random tweets	
          while(tweet.text.toLowerCase().indexOf('#pokefact') == -1)
            tweet = msg.random tweets	
          msg.send "PokeFACT: " + tweet.text.replace(/\#pokefact/i, "");
        else
          msg.reply "Couldn't find a PokeFACT"
