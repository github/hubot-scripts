# Description:
#     The official Giphy Bot
#
# Commands:
#     giphy help - commands available
#     giphy <query> - translate to gif
#     giphy bomb <query> - return 5 random found gifs
#     giphy trending - get a random recently trending gif
#
# Author:
#     Giphy, Inc.

module.exports = (robot) ->

    # listen for giphy
    robot.hear /^(giphy|gif) (.*)/i, (msg) ->
        bot msg, msg.match[0], (url) ->                
            msg.send url

    # giphy bot using public beta key
    bot = (msg, query, cb) ->
        msg.http('http://api.giphy.com/v1/bots/hubot')
        .query
            q: query
            api_key: 'dc6zaTOxFJmzC'
        .get() (err, res, body) ->
            response = JSON.parse(body)
            gifs = response.data
            for gif in gifs
                cb gif.images.original.url
