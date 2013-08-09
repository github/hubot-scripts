# Description:
#   Loads a specified HTTP cat error image from
#   http://httpcats.herokuapp.com/
#   based on user input
#
# Dependencies:
#    none
#
# Configuration:
#   None
#
# Commands:
#    hubot httpcat <status> - get your status cat image
#
#    hubot httpcat help - explains usage
#
# Notes:
#    None
#
# Author:
#    @commadelimited

codes = [100, 101, 200, 201, 202, 204, 206, 207, 300, 301, 303, 304,
        305, 307, 400, 401, 402, 403, 404, 405, 406, 408, 409, 410,
        411, 413, 414, 416, 417, 418, 422, 423, 424, 425, 426, 429,
        431, 444, 450, 500, 502, 503, 506, 507, 508, 509, 599]

module.exports = (robot) ->
    robot.respond /httpcat (.+)/i, (msg) ->
        status = parseInt(msg.match[1], 10)
        if (codes.indexOf( status ) > -1)
            msg.send 'http://httpcats.herokuapp.com/' + status + '.jpg'
        else
            msg.send "That's not a valid HTTP status code, sorry amigo!"


    robot.respond /httpcat help/i, (msg) ->
        msg.send "Usage: httpcat <http status code>; a number"