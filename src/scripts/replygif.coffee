# Description:
#   Show ReplyGifs based on tags. See http://replygif.net.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_REPLYGIF_API_KEY: the api key for replygif.net, defaults to public key "39YAprx5Yi"
#
# Commands:
#   hubot replygif <tag> - Embed a random ReplyGif with the given tag.
#   hubot replygif me <tag> - Same as `hubot replygif <tag>`.
#   hubot replygif id <id> - Embed the ReplyGif with the given id
#   hubot replygif me id <id> - Same as `hubot replygif id <id>`.
#
# Notes:
#   Use 'rg' as shorthand for the 'replygif' command
#
# Author:
#   altschuler (previous non-api version by sumeetjain, meatballhat)

apiKey = process.env.HUBOT_REPLYGIF_API_KEY or "39YAprx5Yi"

apiUrl = "http://replygif.net/api/gifs?api-key=#{apiKey}"

module.exports = (robot) ->
    apiCall = (msg, failMsg, query) ->
        robot.http(apiUrl + query).get() (err, res, body) ->
            try
                gifs = JSON.parse body
            if not gifs? or not gifs.length
                msg.send failMsg
            else
                msg.send (msg.random gifs).file

    robot.hear /.*replygif\.net\/(i\/)?(\d+)(?!.*\.gif).*/i, (msg) ->
        id = msg.match[2]
        msg.send "http://replygif.net/i/#{id}.gif"

    robot.respond /(replygif|rg)( me)? ([\w|\ ]+)/i, (msg) ->
        tag = msg.match[3]
        if tag is "id" then return # hubot's looking for an id
        apiCall msg, "I don't know that reaction", "&tag=#{tag}"

    robot.respond /(replygif|rg)( me)? id (\d+)/i, (msg) ->
        id = msg.match[3]
        apiCall msg, "I don't any gifs with that id", "&id=#{id}"
