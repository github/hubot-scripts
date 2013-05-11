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
#   hubot horse - Display a randomly selected insight on the world from Horse_Ebooks
#
# Author:
#   lavelle

module.exports = (robot) ->
    robot.respond /horse/i, (msg) ->
        url = 'http://api.twitter.com/1/statuses/user_timeline.json'
        msg
            .http(url)
            .query
                screen_name: 'horse_ebooks'
                count: 10
            .get() (err, res, body) ->
                tweets = JSON.parse(body)

                if tweets? and tweets.length > 0
                    n = Math.floor Math.random() * tweets.length or 0
                    msg.send(tweets[n].text)
                else
                    msg.reply "Couldn't find any insights for you this time"
